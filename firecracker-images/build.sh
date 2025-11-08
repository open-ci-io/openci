#!/bin/bash
set -euo pipefail

# Firecracker Ubuntu Rootfs Image Builder (virt-customize version)
# Ubuntu + Ruby + GitHub Actions Runner

# Configuration
UBUNTU_VERSION="jammy"  # Ubuntu 22.04
CLOUD_IMAGE_URL="https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
IMAGE_NAME="ubuntu-runner.ext4"
IMAGE_SIZE="10G"
RUNNER_VERSION="2.321.0"  # GitHub Actions Runner version
TEMP_IMAGE="temp-cloudimg.img"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check required tools
check_dependencies() {
    local deps=("virt-customize" "qemu-img" "wget")
    for cmd in "${deps[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            log_error "Required command '$cmd' not found."
            log_error "Install with: sudo apt-get install -y libguestfs-tools qemu-utils wget"
            exit 1
        fi
    done
    log_info "All dependencies are installed"
}

# Download Ubuntu Cloud Image
download_image() {
    log_info "Downloading Ubuntu $UBUNTU_VERSION Cloud Image"

    if [ -f "$TEMP_IMAGE" ]; then
        log_warn "Temporary image already exists. Remove it? (y/n)"
        read -r response
        if [ "$response" = "y" ]; then
            rm "$TEMP_IMAGE"
        else
            log_info "Using existing temporary image"
            return
        fi
    fi

    wget -O "$TEMP_IMAGE" "$CLOUD_IMAGE_URL"
    log_info "Cloud image downloaded"
}

# Resize image
resize_image() {
    log_info "Resizing image to $IMAGE_SIZE"
    qemu-img resize "$TEMP_IMAGE" "$IMAGE_SIZE"
    log_info "Image resized"
}

# Create runner setup script
create_runner_setup_script() {
    log_info "Creating runner setup script"

    cat > /tmp/setup-runner.sh <<'EOF'
#!/bin/bash
set -e

# Check if already setup
if [ -f /opt/.runner-setup-complete ]; then
    echo "Runner already setup, skipping"
    exit 0
fi

echo "Installing required packages..."
export DEBIAN_FRONTEND=noninteractive

# Wait for network
until ping -c1 archive.ubuntu.com &>/dev/null; do
    echo "Waiting for network..."
    sleep 2
done

apt-get update
apt-get install -y ruby-full git curl wget tmux jq sudo build-essential

RUNNER_VERSION="2.321.0"
RUNNER_DIR="/opt/actions-runner"

echo "Setting up GitHub Actions Runner"

mkdir -p "$RUNNER_DIR"
cd "$RUNNER_DIR"

curl -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L \
    https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

tar xzf actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz
rm actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

./bin/installdependencies.sh

useradd -m -s /bin/bash runner || true
chown -R runner:runner "$RUNNER_DIR"

# Mark as complete
touch /opt/.runner-setup-complete

echo "Runner setup completed"
EOF

    chmod +x /tmp/setup-runner.sh
}

# Create runner startup script
create_startup_script() {
    log_info "Creating runner startup script"

    cat > /tmp/start-runner.sh <<'EOF'
#!/bin/bash
set -e

# Wait for JIT config file
while [ ! -f /etc/runner-jitconfig ]; do
    echo "Waiting for JIT config..."
    sleep 1
done

JIT_CONFIG=$(cat /etc/runner-jitconfig)

cd /opt/actions-runner

# Configure and start runner with JIT config
RUNNER_ALLOW_RUNASROOT=true ./config.sh --jitconfig "$JIT_CONFIG"
RUNNER_ALLOW_RUNASROOT=true ./run.sh
EOF

    chmod +x /tmp/start-runner.sh
}

# Customize image with virt-customize
customize_image() {
    log_info "Customizing image with virt-customize"

    create_runner_setup_script
    create_startup_script

    # Note: Skipping --update and package installation during image build
    # These will be handled at VM boot time via cloud-init or startup script
    virt-customize -a "$TEMP_IMAGE" \
        --copy-in /tmp/setup-runner.sh:/opt/ \
        --copy-in /tmp/start-runner.sh:/usr/local/bin/ \
        --copy-in config/runner.service:/etc/systemd/system/ \
        --run-command 'chmod +x /opt/setup-runner.sh' \
        --run-command 'chmod +x /usr/local/bin/start-runner.sh' \
        --run-command 'systemctl enable runner.service' \
        --run-command 'systemctl enable ssh' \
        --run-command 'echo "firecracker-runner" > /etc/hostname' \
        --run-command "sed -i '/UEFI/d' /etc/fstab" \
        --run-command "sed -i '/\/boot\/efi/d' /etc/fstab" \
        --root-password password:firecracker

    log_info "Customization completed"

    # Cleanup temp files
    rm -f /tmp/setup-runner.sh /tmp/start-runner.sh
}

# Convert to EXT4 and extract root partition
convert_to_ext4() {
    log_info "Converting to EXT4 format and extracting root partition"

    if [ -f "$IMAGE_NAME" ]; then
        log_warn "Output image $IMAGE_NAME already exists. Remove it? (y/n)"
        read -r response
        if [ "$response" = "y" ]; then
            rm "$IMAGE_NAME"
        else
            log_error "Aborted"
            exit 1
        fi
    fi

    local TEMP_RAW="temp-raw.img"

    # Convert qcow2 to raw
    log_info "Converting qcow2 to raw format"
    qemu-img convert -f qcow2 -O raw "$TEMP_IMAGE" "$TEMP_RAW"

    # Get partition info (find Linux filesystem partition)
    log_info "Extracting partition information"
    local PART_INFO=$(fdisk -l "$TEMP_RAW" | grep "Linux filesystem" | head -1)
    local START_SECTOR=$(echo "$PART_INFO" | awk '{print $2}')
    local SECTORS=$(echo "$PART_INFO" | awk '{print $4}')

    log_info "Found Linux partition: start=$START_SECTOR, sectors=$SECTORS"

    # Extract the root partition only
    log_info "Extracting root partition"
    dd if="$TEMP_RAW" of="$IMAGE_NAME" bs=512 skip="$START_SECTOR" count="$SECTORS" status=progress

    # Clean up temp raw image
    rm -f "$TEMP_RAW"

    # Check filesystem
    log_info "Checking filesystem"
    e2fsck -f -y "$IMAGE_NAME" || log_warn "Filesystem check completed with warnings"

    # Resize to desired size
    log_info "Resizing to $IMAGE_SIZE"
    truncate -s "$IMAGE_SIZE" "$IMAGE_NAME"
    resize2fs "$IMAGE_NAME"

    log_info "Conversion and extraction completed"
}

# Cleanup temporary files
cleanup() {
    log_info "Cleaning up temporary files"
    rm -f "$TEMP_IMAGE"
    log_info "Cleanup completed"
}

# Main build process
main() {
    log_info "Starting Firecracker rootfs image build (virt-customize method)"
    log_info ""

    check_dependencies
    download_image
    resize_image
    customize_image
    convert_to_ext4
    cleanup

    log_info ""
    log_info "Build completed successfully!"
    log_info "Output: $IMAGE_NAME"
    log_info "Image size: $IMAGE_SIZE"
    log_info ""
    log_info "Next steps:"
    log_info "1. Download a Firecracker kernel (vmlinux)"
    log_info "2. Create a Firecracker VM config pointing to this rootfs"
    log_info "3. Start your Firecracker VM"
}

main "$@"
