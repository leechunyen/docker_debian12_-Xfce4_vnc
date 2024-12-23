#!/bin/bash

# Function to check if Docker is installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo "Docker could not be found, please install Docker first."
        exit 1
    fi
}

# Function to get user input for container name
get_container_name() {
    read -p "Enter a custom container name (default: $IMAGE_NAME): " container_name
    CONTAINER_NAME=${container_name:-$IMAGE_NAME}
}

# Function to get user input for VNC password
get_vnc_password() {
    read -p "Do you want to change the VNC password? (y/n) [default: y]: " change_pass
    if [[ "$change_pass" == [Nn]* ]]; then
        VNC_PASSWORD="password"
    else
        read -s -p "Enter new VNC password: " vnc_pass
        echo
        VNC_PASSWORD="$vnc_pass"
    fi
}

# Function to check if port is available
check_port() {
    local port=$1
    if ss -tuln | grep -q ":$port "; then
        return 1 # Port is in use
    else
        return 0 # Port is available
    fi
}

# Function to get user input for ports with availability check
get_ports() {
    while true; do
        read -p "Enter VNC port (default: 5901): " vnc_port
        VNC_PORT=${vnc_port:-5901}
        if ! check_port $VNC_PORT; then
            echo "Port $VNC_PORT is already in use. Please choose a different port for VNC."
        else
            break
        fi
    done

    while true; do
        read -p "Enter noVNC port (default: 8080): " novnc_port
        NO_VNC_PORT=${novnc_port:-8080}
        if ! check_port $NO_VNC_PORT; then
            echo "Port $NO_VNC_PORT is already in use. Please choose a different port for noVNC."
        else
            break
        fi
    done
}

# Function to get host IP
get_host_ip() {
    # Using hostname -I to get the IP (works on most modern systems)
    HOST_IP=$(hostname -I | awk '{print $1}')
}

# Function to ask if user wants to auto-start the container
get_auto_start() {
    read -p "Do you want to auto-start the container on host reboot? (y/n) [default: y]: " auto_start
    if [[ "$auto_start" == [Nn]* ]]; then
        AUTO_START="no"
    else
        AUTO_START="yes"
    fi
}

# Main script execution
check_docker

# Define image name
IMAGE_NAME="debian12-xfce4-vnc"

# Get user input
get_container_name
get_vnc_password
get_ports
get_auto_start
get_host_ip

# Check if the Docker image already exists
if docker image inspect $IMAGE_NAME &> /dev/null; then
    read -p "$IMAGE_NAME image already exists. Do you want to rebuild it? (y/n) [default: n]: " rebuild
    if [[ "$rebuild" != [Yy]* ]]; then
        echo "Using existing image."
    else
        echo "Rebuilding image..."
        if ! docker build -t $IMAGE_NAME .; then
            echo "Failed to rebuild the Docker image."
            exit 1
        fi
    fi
else
    echo "Building new Docker image..."
    if ! docker build -t $IMAGE_NAME .; then
        echo "Failed to build the Docker image."
        exit 1
    fi
fi

# Run Docker container
AUTO_START_FLAG=""
if [ "$AUTO_START" = "yes" ]; then
    AUTO_START_FLAG="--restart=always"
fi

if ! docker run -d \
    $AUTO_START_FLAG \
    --name $CONTAINER_NAME \
    -p $NO_VNC_PORT:80 \
    -p $VNC_PORT:5901 \
    -e VNC_PASSWORD="$VNC_PASSWORD" \
    $IMAGE_NAME; then
    echo "Failed to run the Docker container."
    exit 1
fi

# Output instructions
echo "VNC server is running:"
echo " - Access via noVNC: http://$HOST_IP:$NO_VNC_PORT/vnc.html"
echo " - Access via VNC client: connect to $HOST_IP on port $VNC_PORT"
echo "VNC password: $VNC_PASSWORD"
echo "Auto-start on reboot: $AUTO_START"