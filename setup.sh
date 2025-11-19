#!/bin/bash

echo "Creating directory structure at /home/alien/keycloak..."
sudo mkdir -p /home/alien/keycloak/postgres
sudo mkdir -p /home/alien/keycloak/keycloak-0
sudo mkdir -p /home/alien/keycloak/keycloak-1

echo "Setting permissions..."
sudo chmod -R 777 /home/alien/keycloak

echo "Setup complete!"
echo "Directory structure created:"
ls -la /home/alien/keycloak
