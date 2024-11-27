#!/bin/bash

ssh_path="$HOME/.ssh"
public_key="$SSH_PUBLIC_KEY"

# Check if authorized_keys file exists
if [ ! -f "$ssh_path/authorized_keys" ]; then
    echo "No authorized_keys file found in $ssh_path, creating..."
    # Install SSH public keys
    mkdir -p "$ssh_path"
    chmod 700 "$ssh_path"
    touch "$ssh_path/authorized_keys"
    chmod 600 "$ssh_path/authorized_keys"
fi

# Check if keys are already installed
if grep -q "$public_key" "$ssh_path/authorized_keys"; then
    echo "Public access key is already installed."
else
    echo "Installing public access key..."
    echo "$public_key" >> "$ssh_path/authorized_keys"
fi