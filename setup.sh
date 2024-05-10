#!/bin/bash

echo "Starting VPN setup..."

# Ensure the script is running as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

set -e

# Function to check and load environment variables
setup_env() {
    echo "Checking for .env file..."
    if [ ! -f ".env" ]; then
        echo "No .env file found. Copying from .env.example..."
        if [ -f ".env.example" ]; then
            cp .env.example .env
            echo "Please configure the .env file with your settings."
            exit 1
        else
            echo "Error: .env.example file not found!"
            exit 1
        fi
    else
        echo ".env file found. Loading environment variables..."
        set -a
        while read -r line; do
            if [[ "$line" =~ ^[^#]*= ]]; then
                export "$line"
            fi
        done < .env
        set +a
    fi
}

# Function to configure V2Ray config.json
configure_v2ray() {
    echo "Configuring V2Ray..."
    if [ -f "./v2ray/template_config.json" ]; then
        envsubst < "./v2ray/template_config.json" > "./v2ray/config.json"
        echo "V2Ray configuration is updated."
    else
        echo "Error: V2Ray template_config.json not found!"
        exit 1
    fi
}

# Function to install Docker and Docker Compose
install_docker() {
    echo "Checking for Docker..."
    if ! command -v docker &> /dev/null; then
        echo "Docker could not be found, installing Docker..."
        curl -fsSL https://get.docker.com -o get-docker.sh
        sh get-docker.sh
    else
        echo "Docker is already installed."
    fi

    echo "Checking for Docker Compose..."
    if ! command -v docker-compose &> /dev/null; then
        echo "Docker Compose could not be found, installing Docker Compose..."
        curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
    else
        echo "Docker Compose is already installed."
    fi
}

# Function to update and upgrade the system
update_system() {
    echo "Updating and upgrading the system..."
    apt update && apt upgrade -y
}

# Function to configure firewall
configure_firewall() {
    echo "Setting up the firewall..."
    ufw allow 22/tcp
    ufw allow 80/tcp
    ufw allow 443/tcp
    ufw allow 51820/udp
    ufw enable
}

# Main function to set up the VPN
setup_vpn() {
    setup_env
    configure_v2ray
    install_docker
    update_system
    configure_firewall
    echo "Launching Docker containers..."
    docker-compose up -d
    echo "Setup complete. Validate by checking the status of Docker containers."
    docker ps
}

# Run the main function
setup_vpn

exit 0
