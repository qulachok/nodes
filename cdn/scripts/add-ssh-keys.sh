#!/bin/bash

ssh_path="$HOME/.ssh"
public_key="$SSH_PUBLIC_KEY"

# Check if keys are already installed
if grep -q "$public_key" "$ssh_path/authorized_keys"; then
    echo "Public access key is already installed."
else
    echo "Installing public access key..."
    echo "$public_key" >> "$ssh_path/authorized_keys"
fi