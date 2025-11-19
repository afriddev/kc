#!/bin/bash
set -e

echo "Creating /home/alien/keycloak storage with permissions..."

sudo mkdir -p /home/alien/keycloak
sudo chown -R 1000:1000 /home/alien/keycloak
sudo chmod -R 700 /home/alien/keycloak

echo "✓ Storage directory ready: /home/alien/keycloak"
