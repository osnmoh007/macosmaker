#!/bin/bash

# Default values
DEFAULT_RAM_SIZE="14G"
DEFAULT_CPU_CORES="6"
DEFAULT_DISK_SIZE="64G"
DEFAULT_VNC_PORT="5900"
DEFAULT_WEB_VNC_PORT="8006"
RAM_SIZE=$DEFAULT_RAM_SIZE
CPU_CORES=$DEFAULT_CPU_CORES
DISK_SIZE=$DEFAULT_DISK_SIZE
VNC_PORT=$DEFAULT_VNC_PORT
WEB_VNC_PORT=$DEFAULT_WEB_VNC_PORT

# Function to check if a port is in use
check_port() {
    local PORT=$1
    if sudo netstat -tuln | grep -q ":$PORT"; then
        return 1  # Port is in use
    else
        return 0  # Port is free
    fi
}

# Function to display usage
usage() {
    echo "Usage: $0 [-r RAM_SIZE] [-c CPU_CORES] [-d DISK_SIZE] [-m MACHINE_NAME] [-v VNC_PORT] [-w WEB_VNC_PORT]"
    echo "  -r  RAM_SIZE       Set RAM size (e.g., 14 for 14G)"
    echo "  -c  CPU_CORES      Set the number of CPU cores (e.g., 6)"
    echo "  -d  DISK_SIZE      Set the disk size (e.g., 64G)"
    echo "  -m  MACHINE_NAME   Set the machine name"
    echo "  -v  VNC_PORT       Set the VNC port (e.g., 5900)"
    echo "  -w  WEB_VNC_PORT   Set the host port for web VNC (container port is fixed at 8006)"
    exit 1
}

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -r) RAM_SIZE="${2}G"; shift ;;
        -c) CPU_CORES="$2"; shift ;;
        -d) DISK_SIZE="$2"; shift ;;
        -m) MACHINE_NAME="$2"; shift ;;
        -v) VNC_PORT="$2"; shift ;;
        -w) WEB_VNC_PORT="$2"; shift ;;
        *) usage ;;
    esac
    shift
done

# Prompt for RAM size if not set by flag
if [ -z "$RAM_SIZE" ]; then
    read -p "Enter RAM size (e.g., 14 for 14G): " RAM_SIZE
    RAM_SIZE="${RAM_SIZE}G"
fi

# Prompt for CPU cores if not set by flag
if [ -z "$CPU_CORES" ]; then
    read -p "Enter the number of CPU cores (e.g., 6): " CPU_CORES
fi

# Prompt for disk size if not set by flag
if [ -z "$DISK_SIZE" ]; then
    read -p "Enter the disk size (e.g., 64G): " DISK_SIZE
fi

# Prompt for machine name if not set by flag
if [ -z "$MACHINE_NAME" ]; then
    read -p "Enter the machine name: " MACHINE_NAME
fi

# Prompt for VNC port if not set by flag
if [ -z "$VNC_PORT" ]; then
    read -p "Enter the VNC port (e.g., 5900): " VNC_PORT
fi

# Prompt for web VNC port if not set by flag
if [ -z "$WEB_VNC_PORT" ]; then
    read -p "Enter the host port for web VNC (e.g., 8006): " WEB_VNC_PORT
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker not found. Installing Docker..."

    # Update the package repository
    echo "Updating package repository..."
    sudo apt-get update -y

    # Install required packages
    echo "Installing required packages..."
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    # Add Docker's official GPG key
    echo "Adding Docker's official GPG key..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # Set up the stable repository
    echo "Setting up the Docker stable repository..."
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Update the package repository again
    echo "Updating package repository..."
    sudo apt-get update -y

    # Install Docker Engine
    echo "Installing Docker Engine..."
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io

    echo "Docker installation complete."
else
    echo "Docker is already installed."
fi

# Define macOS version codes
declare -A MACOS_VERSIONS=(
    [1]="sonoma"
    [2]="ventura"
    [3]="monterey"
    [4]="big-sur"
)

# Display available macOS versions
echo "Available macOS versions:"
echo "1) sonoma: macOS Sonoma"
echo "2) ventura: macOS Ventura"
echo "3) monterey: macOS Monterey"
echo "4) big-sur: macOS Big Sur"

# Prompt for macOS version selection if not set by flag
if [ -z "$MACOS_CODE" ]; then
    while true; do
        read -p "Enter the number for the macOS version you want to use: " choice
        MACOS_CODE="${MACOS_VERSIONS[$choice]}"
        
        if [ -z "$MACOS_CODE" ]; then
            echo "Invalid choice. Please select a valid macOS version."
        else
            break
        fi
    done
fi

# Check the availability of VNC port
if ! check_port $VNC_PORT; then
    echo "VNC port $VNC_PORT is already in use. Please choose a different port."
    exit 1
fi

# Check the availability of web VNC port
if ! check_port $WEB_VNC_PORT; then
    echo "Web VNC port $WEB_VNC_PORT is already in use. Please choose a different port."
    exit 1
fi

# Create a unique container name using machine name and VNC port
CONTAINER_NAME="${MACHINE_NAME}-${VNC_PORT}"

# Define volume path based on container name
VOLUME_PATH="/root/macos/$CONTAINER_NAME"

# Create the directory if it doesn't exist
if [ ! -d "$VOLUME_PATH" ]; then
    echo "Creating volume directory: $VOLUME_PATH"
    mkdir -p "$VOLUME_PATH"
fi

# Verify Docker installation
echo "Verifying Docker installation..."
docker --version

# Run the Docker container with the specified parameters
echo "Running the Docker container..."
docker run -d \
    -p $WEB_VNC_PORT:8006 \
    -p $VNC_PORT:5900/tcp \
    -p $VNC_PORT:5900/udp \
    -v "$VOLUME_PATH:/storage" \
    --device=/dev/kvm \
    --cap-add NET_ADMIN \
    -e VERSION="$MACOS_CODE" \
    -e RAM_SIZE="$RAM_SIZE" \
    -e CPU_CORES="$CPU_CORES" \
    -e DISK_SIZE="$DISK_SIZE" \
    --name "$CONTAINER_NAME" \
    --restart always \
    dockurr/macos

# Fetch the external IP address
EXTERNAL_IP=$(curl -s ifconfig.me)

# Display completion message
echo "All done! You can access macOS via web VNC at $EXTERNAL_IP:$WEB_VNC_PORT or VNC connection at $EXTERNAL_IP:$VNC_PORT."
