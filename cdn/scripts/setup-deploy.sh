#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Import common functions
. <(wget -qO- https://raw.githubusercontent.com/qulachok/nodes/refs/heads/main/cdn/scripts/common.sh)

# Install environment
. <(wget -qO- https://raw.githubusercontent.com/qulachok/nodes/refs/heads/main/cdn/scripts/environment.sh)

username="deploy"
ssh_path="$HOME/.ssh"
public_key="$SSH_PUBLIC_KEY"

# Create or update user
if id "$username" &>/dev/null; then
    echo "User '$username' already exists."
else
    echo "Creating new user $username..."
    adduser --disabled-password --gecos "" $username
    if [[ $? -ne 0 ]]; then
        echo "Failed to create user $username."
        exit 1
    fi

    usermod -aG docker $username
    if [[ $? -ne 0 ]]; then
        echo "Failed to set docker group to $username."
        exit 1
    fi

    echo "Deploy user '$username' was successfully created."
fi

if grep -q "$public_key" "$ssh_path/authorized_keys"; then
    echo "Public access key is already installed."
else
    echo "Installing public access key..."
    echo "$public_key" >> "$ssh_path/authorized_keys"
fi

download "https://raw.githubusercontent.com/qulachok/nodes/refs/heads/main/cdn/scripts/setup-user.sh" "/home/$username/setup.sh"

chmod +x "/home/$username/setup.sh"
if [[ $? -ne 0 ]]; then
  echo "Failed to make setup.sh executable"
  exit 1
fi

echo "Script completed successfully."
