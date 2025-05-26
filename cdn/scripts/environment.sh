#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Constants
ssh_path="$HOME/.ssh"
rcfile_path="$HOME/.bashrc"
config_path="$HOME/.config/$PROJECT_NAME"
setup_config_path="$config_path/.config"
identity_config_path="$config_path/.identity"

# Check if authorized_keys file exists
if [ ! -f "$ssh_path/authorized_keys" ]; then
    echo "No authorized_keys file found in $ssh_path, creating..."
    # Install SSH public keys
    mkdir -p "$ssh_path"
    chmod 700 "$ssh_path"
    touch "$ssh_path/authorized_keys"
    chmod 600 "$ssh_path/authorized_keys"
fi

# Create config directory
mkdir -p "$config_path"

# Append to .bashrc
if ! grep -q "$setup_config_path" "$rcfile_path"; then
  echo "Appending to .bashrc..."
  cat << EOF >> "$rcfile_path"
if [ -f "$setup_config_path" ]; then
    . "$setup_config_path"
fi
EOF
else
  echo "Already appended to .bashrc, skipping..."
fi

# Create .config file
if [ ! -f "$setup_config_path" ]; then
  echo "Creating .config file..."
  cat << EOF > "$setup_config_path"
if [ -f "$identity_config_path" ]; then
    . "$identity_config_path"
fi
EOF
else
  echo "Already created .config file, skipping..."
fi

# Create .identity file
if [ ! -f "$identity_config_path" ]; then
  echo "Creating .identity file..."
  touch "$identity_config_path"
else
  echo "Already created .identity file, skipping..."
fi
