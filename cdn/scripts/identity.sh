#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Constants
rcfile_path="$HOME/.bashrc"
config_path="$HOME/.config/$PROJECT_NAME"
setup_config_path="$config_path/.config"
identity_config_path="$config_path/.identity"

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

# Create config directory
mkdir -p "$config_path"

# Create .config file
if ! grep -q "$identity_config_path" "$setup_config_path"; then
  echo "Creating .config file..."
  cat << EOF > "$setup_config_path"
if [ -f "$identity_config_path" ]; then
    . "$identity_config_path"
fi
EOF
else
  echo "Already created .config file, skipping..."
fi

# Check .identity file
if ! grep -q "$SSH_PUBLIC_KEY" "$identity_config_path"; then
  echo "SSH public key not found in .identity file, exiting..."
  exit 1
else
  echo "SSH public key found in .identity file, continuing..."
fi
