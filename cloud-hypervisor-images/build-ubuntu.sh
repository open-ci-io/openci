#!/bin/bash
set -euo pipefail

# Cloud Hypervisor Ubuntu Image Builder
# Creates Ubuntu images compatible with Cloud Hypervisor

# Configuration
UBUNTU_VERSION="jammy"  # Ubuntu 22.04
CLOUD_IMAGE_URL="https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
OUTPUT_IMAGE="ubuntu-cloudhypervisor.raw"
IMAGE_SIZE="20G"
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
    local deps=("virt-customize" "qemu-img" "wget" "cloud-localds")
    for cmd in "${deps[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            log_error "Required command '$cmd' not found."
            log_error "Install with: sudo apt-get install -y libguestfs-tools qemu-utils wget cloud-image-utils"
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

# Customize image with virt-customize
customize_image() {
    log_info "Customizing image with virt-customize"

    # Basic customization for Cloud Hypervisor
    virt-customize -a "$TEMP_IMAGE" \
        --update \
        --install openssh-server,curl,wget,git,vim,tmux,htop,cloud-init \
        --run-command 'systemctl enable ssh' \
        --run-command 'echo "cloud-hypervisor-vm" > /etc/hostname' \
        --run-command "sed -i '/UEFI/d' /etc/fstab" \
        --run-command "sed -i '/\/boot\/efi/d' /etc/fstab" \
        --run-command 'systemctl disable systemd-networkd-wait-online.service' \
        --run-command 'systemctl mask systemd-networkd-wait-online.service' \
        --root-password password:ubuntu123

    log_info "Customization completed"
}

# Convert to RAW format
convert_to_raw() {
    log_info "Converting to RAW format"

    if [ -f "$OUTPUT_IMAGE" ]; then
        log_warn "Output image $OUTPUT_IMAGE already exists. Remove it? (y/n)"
        read -r response
        if [ "$response" = "y" ]; then
            rm "$OUTPUT_IMAGE"
        else
            log_error "Aborted"
            exit 1
        fi
    fi

    # Convert qcow2 to raw
    qemu-img convert -f qcow2 -O raw "$TEMP_IMAGE" "$OUTPUT_IMAGE"

    log_info "Conversion completed"
}

# Create cloud-init ISO
create_cloud_init() {
    log_info "Creating cloud-init configuration"

    # Create meta-data
    cat > meta-data <<EOF
instance-id: cloud-hypervisor-vm
local-hostname: ubuntu-vm
EOF

    # Create user-data with default credentials
    cat > user-data <<EOF
#cloud-config
users:
  - name: ubuntu
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys: []
    lock_passwd: false
    passwd: \$6\$rounds=4096\$saltsalt\$IuCe/8hpH8RrPR5N0K0xCZJXwLKVKyK5KHx.r6SqX7qRXQZWKkPGJBrV0nKlPvvV7qOYH1n9pXQ0N6LxW7J0Q0

ssh_pwauth: true

package_update: true
package_upgrade: false

packages:
  - build-essential
  - git
  - curl

runcmd:
  - systemctl restart ssh
  - echo "Cloud-init completed" > /var/log/cloud-init-done

power_state:
  mode: reboot
  timeout: 300
  condition: true
EOF

    # Generate cloud-init ISO
    cloud-localds cloud-init.img user-data meta-data

    log_info "cloud-init.img created (user: ubuntu, pass: ubuntu123)"
}

# Cleanup temporary files
cleanup() {
    log_info "Cleaning up temporary files"
    rm -f "$TEMP_IMAGE" meta-data user-data
    log_info "Cleanup completed"
}

# Main build process
main() {
    log_info "Starting Cloud Hypervisor Ubuntu image build"
    log_info ""

    check_dependencies
    download_image
    resize_image
    customize_image
    convert_to_raw
    create_cloud_init
    cleanup

    log_info ""
    log_info "Build completed successfully!"
    log_info "Output files:"
    log_info "  - Root filesystem: $OUTPUT_IMAGE"
    log_info "  - Cloud-init ISO: cloud-init.img"
    log_info ""
    log_info "Credentials:"
    log_info "  - Username: ubuntu"
    log_info "  - Password: ubuntu123"
    log_info ""
    log_info "Next steps:"
    log_info "  Run: ./start-vm.sh"
}

main "$@"
