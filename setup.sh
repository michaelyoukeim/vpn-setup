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
        set -a # Automatically export all variables
        while read -r line; do
            if [[ "$line" =~ ^[^#]*= ]]; then
                export "$line"
            fi
        done < .env
        set +a
    fi
}

# Function to install Docker and Docker Compose
install_docker() {
    echo "Checking for Docker..."
    if ! command -v docker &> /dev/null; then
        echo "Docker could not be found, installing Docker..."
        curl -fsSL https://get.docker.com -o get-docker.sh && yes | sh get-docker.sh
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

# Function to install and configure firewall
configure_firewall() {
    echo "Checking for UFW (Uncomplicated Firewall)..."
    if ! command -v ufw &> /dev/null; then
        echo "UFW is not installed. Installing now..."
        apt-get update
        apt-get install ufw -y
    fi

    echo "Configuring UFW rules..."
    for port in 22/tcp 80/tcp 443/tcp 51820/udp; do
        if ! ufw status | grep -q "$port"; then
            ufw allow "$port"
        fi
    done

    echo "y" | ufw enable
    ufw status verbose
}

# Main function to set up the VPN
setup_vpn() {
    setup_env
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
