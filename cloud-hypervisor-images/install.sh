#!/bin/bash
set -euo pipefail

# Cloud Hypervisor Installation Script for Ubuntu/Debian
# Installs Cloud Hypervisor on Hetzner dedicated machines or similar Linux hosts

# Configuration
CH_VERSION="v44.0"  # Latest stable version as of 2025
INSTALL_DIR="/usr/local/bin"
ARCH=$(uname -m)

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

log_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        log_error "This script must be run as root (use sudo)"
        exit 1
    fi
    log_info "Running as root"
}

# Check system requirements
check_system() {
    log_step "Checking system requirements"

    # Check CPU virtualization support
    if ! grep -qE 'vmx|svm' /proc/cpuinfo; then
        log_error "CPU doesn't support virtualization (Intel VT-x or AMD-V)"
        exit 1
    fi
    log_info "CPU virtualization support detected"

    # Check kernel version
    KERNEL_VERSION=$(uname -r | cut -d. -f1,2)
    log_info "Kernel version: $KERNEL_VERSION"

    # Check architecture
    if [ "$ARCH" != "x86_64" ] && [ "$ARCH" != "aarch64" ]; then
        log_error "Unsupported architecture: $ARCH"
        exit 1
    fi
    log_info "Architecture: $ARCH"
}

# Install dependencies
install_dependencies() {
    log_step "Installing dependencies"

    apt-get update
    apt-get install -y \
        libguestfs-tools \
        qemu-utils \
        wget \
        curl \
        cloud-image-utils \
        genisoimage \
        bridge-utils \
        iproute2

    log_info "Dependencies installed"
}

# Enable KVM
enable_kvm() {
    log_step "Enabling KVM support"

    # Load KVM modules
    if [ "$ARCH" = "x86_64" ]; then
        if grep -q vmx /proc/cpuinfo; then
            modprobe kvm_intel || log_warn "kvm_intel module already loaded or not available"
        elif grep -q svm /proc/cpuinfo; then
            modprobe kvm_amd || log_warn "kvm_amd module already loaded or not available"
        fi
    fi

    modprobe kvm || log_warn "kvm module already loaded or not available"

    # Check if /dev/kvm exists
    if [ ! -e /dev/kvm ]; then
        log_error "/dev/kvm does not exist. KVM may not be properly configured"
        exit 1
    fi

    # Set permissions
    chmod 666 /dev/kvm
    log_info "KVM enabled and /dev/kvm permissions set"
}

# Download and install Cloud Hypervisor
install_cloud_hypervisor() {
    log_step "Installing Cloud Hypervisor $CH_VERSION"

    # Determine binary name based on architecture
    if [ "$ARCH" = "x86_64" ]; then
        BINARY_NAME="cloud-hypervisor-static"
    elif [ "$ARCH" = "aarch64" ]; then
        BINARY_NAME="cloud-hypervisor-static-aarch64"
    fi

    # Download URL
    DOWNLOAD_URL="https://github.com/cloud-hypervisor/cloud-hypervisor/releases/download/${CH_VERSION}/${BINARY_NAME}"

    log_info "Downloading from: $DOWNLOAD_URL"

    # Download binary
    wget -O /tmp/cloud-hypervisor "$DOWNLOAD_URL"

    # Install to system
    mv /tmp/cloud-hypervisor "$INSTALL_DIR/cloud-hypervisor"
    chmod +x "$INSTALL_DIR/cloud-hypervisor"

    log_info "Cloud Hypervisor installed to $INSTALL_DIR/cloud-hypervisor"

    # Verify installation
    "$INSTALL_DIR/cloud-hypervisor" --version
}

# Download firmware (for UEFI boot)
download_firmware() {
    log_step "Downloading hypervisor firmware"

    FIRMWARE_DIR="/opt/cloud-hypervisor"
    mkdir -p "$FIRMWARE_DIR"

    # Download rust-hypervisor-firmware
    wget -O "$FIRMWARE_DIR/hypervisor-fw" \
        https://github.com/cloud-hypervisor/rust-hypervisor-firmware/releases/download/0.4.2/hypervisor-fw

    chmod +x "$FIRMWARE_DIR/hypervisor-fw"

    log_info "Firmware downloaded to $FIRMWARE_DIR/hypervisor-fw"
}

# Setup network bridge (optional but recommended)
setup_network() {
    log_step "Setting up network bridge"

    # Check if bridge already exists
    if ip link show virbr0 &>/dev/null; then
        log_warn "Bridge virbr0 already exists, skipping"
        return
    fi

    # Create bridge
    ip link add virbr0 type bridge
    ip addr add 192.168.100.1/24 dev virbr0
    ip link set virbr0 up

    # Enable IP forwarding
    echo 1 > /proc/sys/net/ipv4/ip_forward

    # Make it persistent
    if ! grep -q "net.ipv4.ip_forward=1" /etc/sysctl.conf; then
        echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
    fi

    log_info "Network bridge virbr0 created (192.168.100.1/24)"
}

# Create systemd service (optional)
create_systemd_template() {
    log_step "Creating systemd service template"

    cat > /etc/systemd/system/cloud-hypervisor@.service <<'EOF'
[Unit]
Description=Cloud Hypervisor VM - %i
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/cloud-hypervisor --api-socket /run/cloud-hypervisor-%i.sock
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    log_info "Systemd service template created at /etc/systemd/system/cloud-hypervisor@.service"
}

# Print summary
print_summary() {
    log_info ""
    log_info "=========================================="
    log_info "Cloud Hypervisor Installation Complete!"
    log_info "=========================================="
    log_info ""
    log_info "Installation details:"
    log_info "  - Cloud Hypervisor: $INSTALL_DIR/cloud-hypervisor"
    log_info "  - Firmware: /opt/cloud-hypervisor/hypervisor-fw"
    log_info "  - Bridge network: virbr0 (192.168.100.1/24)"
    log_info ""
    log_info "Next steps:"
    log_info "  1. Build an Ubuntu image: ./build-ubuntu.sh"
    log_info "  2. Start a VM: ./start-vm.sh"
    log_info ""
    log_info "Quick test:"
    log_info "  cloud-hypervisor --version"
    log_info ""
}

# Main installation process
main() {
    log_info "Starting Cloud Hypervisor installation"
    log_info ""

    check_root
    check_system
    install_dependencies
    enable_kvm
    install_cloud_hypervisor
    download_firmware
    setup_network
    create_systemd_template
    print_summary
}

main "$@"
