#!/bin/bash
set -euo pipefail

# Download Linux kernel for Cloud Hypervisor direct boot
# This is faster and simpler than UEFI firmware boot

KERNEL_VERSION="6.1"
KERNEL_URL="https://s3.amazonaws.com/spec.ccfc.min/firecracker-ci/v1.7/${KERNEL_VERSION}/x86_64/vmlinux-${KERNEL_VERSION}.bin"
KERNEL_OUTPUT="vmlinux-${KERNEL_VERSION}.bin"

# Color output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# Check if kernel already exists
if [ -f "$KERNEL_OUTPUT" ]; then
    log_warn "Kernel $KERNEL_OUTPUT already exists"
    log_warn "Remove it to re-download? (y/n)"
    read -r response
    if [ "$response" != "y" ]; then
        log_info "Using existing kernel"
        exit 0
    fi
    rm "$KERNEL_OUTPUT"
fi

log_info "Downloading Linux kernel ${KERNEL_VERSION}..."
log_info "URL: $KERNEL_URL"

wget -O "$KERNEL_OUTPUT" "$KERNEL_URL"

log_info "Kernel downloaded: $KERNEL_OUTPUT"
log_info "Size: $(du -h $KERNEL_OUTPUT | cut -f1)"
