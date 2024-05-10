#!/bin/bash

echo "Resetting the Docker environment..."

# Ensure the script is running as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

set -e

# Stop all containers
echo "Removing all Docker containers..."
docker rm -f $(docker ps -aq)

# Remove all Docker networks except default ones
echo "Pruning Docker networks..."
docker network prune -f

# Remove all Docker volumes
echo "Pruning Docker volumes..."
docker volume prune -f

# Remove all Docker images
echo "Removing Docker images..."
docker rmi -f $(docker images -q)

echo "Environment has been reset."

exit 0
