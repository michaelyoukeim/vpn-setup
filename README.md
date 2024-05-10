# VPN Setup Guide

## Installation Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/michaelyoukeim/vpn-setup.git /opt/vpn-setup
   cd /opt/vpn-setup
   ```

2. Copy the `.env.example` to `.env` and update the variables accordingly.
   ```bash
   cp .env.example .env
   ```

3. Make the setup script executable:
   ```bash
   chmod +x setup.sh
   ```

4. Run the setup script:
   ```bash
   ./setup.sh
   ```

This will install all necessary components, set up the firewall, and start the VPN services.


## Resetting the Environment

If you need to reset your environment before setting everything up again, you can use the `reset_environment.sh` script provided in the repository. This script will remove all Docker containers, networks, volumes, and images to ensure a clean start.

### Steps to Reset Environment:

1. Make the reset script executable:
   ```bash
   chmod +x reset_environment.sh
   ```

2. Run the reset script:
   ```bash
   ./reset_environment.sh
   ```

This will clean up your Docker environment, allowing you to start fresh with the setup process.