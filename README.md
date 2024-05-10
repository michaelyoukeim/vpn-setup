# VPN Setup Guide

## Installation Instructions

1. Install Git
   ```bash
   sudo apt update
   sudo apt install git -y
   ```

2. Clone the repository:
   ```bash
   git clone https://github.com/michaelyoukeim/vpn-setup.git /opt/vpn-setup
   cd /opt/vpn-setup
   ```

3. Copy the `.env.example` to `.env` and update the variables accordingly.
   ```bash
   cp .env.example .env
   ```

4. Make the setup script executable:
   ```bash
   chmod +x setup.sh
   ```

5. Run the setup script:
   ```bash
   ./setup.sh
   ```

This will install all necessary components, set up the firewall, and start the VPN services.


## Post-Installation Steps

After deploying your Docker containers, follow these steps to ensure everything is configured correctly and to set up your reverse proxy with Nginx Proxy Manager.

### Accessing Nginx Proxy Manager

1. **Open Nginx Proxy Manager**:
   - Navigate to `http://your-server-ip:81` in your web browser to access the Nginx Proxy Manager interface.
   - **Default Login Credentials**:
     - **Email**: `admin@example.com`
     - **Password**: `changeme`
   - It is highly recommended to change these default credentials after your first login to secure your setup.

### Configuring Proxy Host

2. **Set Up a Proxy Host**:
   - Once logged in, proceed to create a new Proxy Host to manage how external traffic reaches your services.
   - **Configuration Steps**:
     - **Source URL**: Enter the domain name that you want to point to your service, e.g., `service.yourdomain.com`.
     - **Protocol**: Select `http` as the protocol.
     - **Destination IP**: Enter `wg-easy`, assuming this is the name of the Docker service you wish to route traffic to.
     - **Destination Port**: Enter `51821`, the port on which your service (in this case, WireGuard) is listening.

### Enabling SSL with Let's Encrypt

3. **Secure Your Proxy Host with SSL**:
   - In the Proxy Host configuration, navigate to the SSL tab.
   - **SSL Certificate**:
     - Choose `Request a new SSL Certificate` from Let's Encrypt.
     - Ensure you check `Force SSL`, `HTTP/2 Support`, and `HSTS Enabled` for better security and performance.
     - Fill out the required information and agree to the terms of service.

### Verifying Configuration

4. **Check Operation**:
   - After configuring the proxy and SSL settings, ensure that you can access your service via the domain name `service.yourdomain.com` securely using HTTPS.
   - Verify that WireGuard and any obfuscation services are functioning correctly by checking connectivity and any relevant logs.

## Security Note

- **Change Default Credentials**: Always change default login credentials for any management interface to prevent unauthorized access.
- **Regularly Update Settings**: Keep your settings and certificates updated to ensure ongoing security and functionality of your services.


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