#!/bin/bash
set -e

echo "Creating /home/alien/keycloak storage with open permissions for local-path-provisioner..."

# Create the directory if it doesn't exist
sudo mkdir -p /home/alien/keycloak

# Set ownership to a generic user/group. The key is the permissions.
# This step isn't as critical as the chmod step below.
sudo chown -R 1000:1000 /home/alien/keycloak

# Set permissions to 777. This allows any user (like 999 for postgres
# and 1000 for keycloak) to create and write to subdirectories inside.
# This is safe for a local single-node cluster like k3s.
sudo chmod -R 777 /home/alien/keycloak

echo "✓ Storage directory ready: /home/alien/keycloak"
