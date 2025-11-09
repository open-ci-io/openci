#!/bin/bash
set -euo pipefail

# Cloud Hypervisor VM Startup Script
# Quick start script for launching Ubuntu VMs with Cloud Hypervisor

# Configuration
VM_NAME="${1:-ubuntu-vm}"
ROOT_IMAGE="${2:-ubuntu-cloudhypervisor.raw}"
CLOUDINIT_IMAGE="${3:-cloud-init.img}"
CPUS="${CH_CPUS:-4}"
MEMORY="${CH_MEMORY:-2048M}"
FIRMWARE="/opt/cloud-hypervisor/hypervisor-fw"
API_SOCKET="/tmp/cloud-hypervisor-${VM_NAME}.sock"
SERIAL_OUTPUT="/tmp/${VM_NAME}-serial.log"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

# Check prerequisites
check_prerequisites() {
    log_step "Checking prerequisites"

    # Check cloud-hypervisor binary
    if ! command -v cloud-hypervisor &> /dev/null; then
        log_error "cloud-hypervisor not found. Run: sudo ./install.sh"
        exit 1
    fi

    # Check firmware
    if [ ! -f "$FIRMWARE" ]; then
        log_error "Firmware not found at $FIRMWARE"
        log_error "Run: sudo ./install.sh"
        exit 1
    fi

    # Check root image
    if [ ! -f "$ROOT_IMAGE" ]; then
        log_error "Root image not found: $ROOT_IMAGE"
        log_error "Run: ./build-ubuntu.sh"
        exit 1
    fi

    # Check cloud-init image
    if [ ! -f "$CLOUDINIT_IMAGE" ]; then
        log_warn "Cloud-init image not found: $CLOUDINIT_IMAGE"
        log_warn "VM will boot without cloud-init"
    fi

    # Check KVM device
    if [ ! -e /dev/kvm ]; then
        log_error "/dev/kvm not found. KVM not available"
        exit 1
    fi

    log_info "All prerequisites met"
}

# Setup TAP network interface
setup_network() {
    log_step "Setting up network"

    TAP_NAME="ch-tap-${VM_NAME}"

    # Check if TAP already exists
    if ip link show "$TAP_NAME" &>/dev/null; then
        log_info "TAP interface $TAP_NAME already exists"
        return
    fi

    # Create TAP interface (requires sudo)
    if [ "$EUID" -eq 0 ]; then
        ip tuntap add "$TAP_NAME" mode tap
        ip link set "$TAP_NAME" up
        ip link set "$TAP_NAME" master virbr0 || log_warn "Could not add TAP to bridge virbr0"
        log_info "TAP interface $TAP_NAME created"
    else
        log_warn "Not running as root. Network setup skipped."
        log_warn "Run with sudo for network access"
    fi
}

# Cleanup previous instances
cleanup_previous() {
    if [ -S "$API_SOCKET" ]; then
        log_warn "Previous instance socket found. Removing..."
        rm -f "$API_SOCKET"
    fi
}

# Start VM
start_vm() {
    log_step "Starting Cloud Hypervisor VM: $VM_NAME"

    cleanup_previous

    # Build disk arguments
    DISK_ARGS="path=$ROOT_IMAGE"
    if [ -f "$CLOUDINIT_IMAGE" ]; then
        DISK_ARGS="${DISK_ARGS},path=$CLOUDINIT_IMAGE"
    fi

    # Build network arguments
    NETWORK_ARGS=""
    if ip link show "ch-tap-${VM_NAME}" &>/dev/null; then
        NETWORK_ARGS="--net tap=ch-tap-${VM_NAME},mac=52:54:00:12:34:56"
    else
        NETWORK_ARGS="--net tap="
    fi

    log_info "VM Configuration:"
    log_info "  Name: $VM_NAME"
    log_info "  CPUs: $CPUS"
    log_info "  Memory: $MEMORY"
    log_info "  Root: $ROOT_IMAGE"
    log_info "  Cloud-init: $CLOUDINIT_IMAGE"
    log_info "  API Socket: $API_SOCKET"
    log_info "  Serial log: $SERIAL_OUTPUT"
    log_info ""

    # Start Cloud Hypervisor
    cloud-hypervisor \
        --api-socket "$API_SOCKET" \
        --kernel "$FIRMWARE" \
        --disk "$DISK_ARGS" \
        --cpus boot=$CPUS \
        --memory size=$MEMORY \
        $NETWORK_ARGS \
        --serial tty \
        --console off \
        2>&1 | tee "$SERIAL_OUTPUT"
}

# Alternative: Start VM in background
start_vm_background() {
    log_step "Starting Cloud Hypervisor VM in background: $VM_NAME"

    cleanup_previous

    # Build disk arguments
    DISK_ARGS="path=$ROOT_IMAGE"
    if [ -f "$CLOUDINIT_IMAGE" ]; then
        DISK_ARGS="${DISK_ARGS},path=$CLOUDINIT_IMAGE"
    fi

    # Build network arguments
    NETWORK_ARGS=""
    if ip link show "ch-tap-${VM_NAME}" &>/dev/null; then
        NETWORK_ARGS="--net tap=ch-tap-${VM_NAME},mac=52:54:00:12:34:56"
    else
        NETWORK_ARGS="--net tap="
    fi

    # Start in background
    nohup cloud-hypervisor \
        --api-socket "$API_SOCKET" \
        --kernel "$FIRMWARE" \
        --disk "$DISK_ARGS" \
        --cpus boot=$CPUS \
        --memory size=$MEMORY \
        $NETWORK_ARGS \
        --serial file="$SERIAL_OUTPUT" \
        --console off \
        > /tmp/cloud-hypervisor-${VM_NAME}.out 2>&1 &

    VM_PID=$!

    log_info "VM started in background (PID: $VM_PID)"
    log_info "Serial output: $SERIAL_OUTPUT"
    log_info "API socket: $API_SOCKET"
    log_info ""
    log_info "Monitor with: tail -f $SERIAL_OUTPUT"
    log_info "Stop with: kill $VM_PID"
}

# Print usage
usage() {
    cat << EOF
Usage: $0 [VM_NAME] [ROOT_IMAGE] [CLOUDINIT_IMAGE]

Environment variables:
  CH_CPUS      - Number of CPUs (default: 4)
  CH_MEMORY    - Memory size (default: 2048M)
  CH_BACKGROUND - Start in background (1 or 0)

Examples:
  # Start with defaults
  ./start-vm.sh

  # Custom VM name
  ./start-vm.sh my-vm

  # Custom configuration
  CH_CPUS=8 CH_MEMORY=4096M ./start-vm.sh my-vm

  # Background mode
  CH_BACKGROUND=1 ./start-vm.sh

Default credentials:
  Username: ubuntu
  Password: ubuntu123

EOF
}

# Main
main() {
    if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
        usage
        exit 0
    fi

    log_info "Cloud Hypervisor VM Launcher"
    log_info ""

    check_prerequisites
    setup_network

    # Check if background mode requested
    if [ "${CH_BACKGROUND:-0}" = "1" ]; then
        start_vm_background
    else
        start_vm
    fi
}

main "$@"
