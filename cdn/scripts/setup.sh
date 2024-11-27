#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Constants
username="qula"

# Functions
download() {
    local file_url=$1
    local file_path=$2
    
    # Download the file
    curl -o "$file_path" "$file_url"
    if [[ $? -ne 0 ]]; then
        echo "Failed to download $file_url"
        return 1
    fi
    
    echo "Successfully downloaded $file_path"
    return 0
}

execute_script() {
    local file_path=$1
    
    # Make the file executable
    chmod +x "$file_path"
    if [[ $? -ne 0 ]]; then
        echo "Failed to make $file_path executable"
        return 1
    fi
    
    # Execute the file
    bash "$file_path"
    if [[ $? -ne 0 ]]; then
        echo "Failed to execute $file_path"
        return 1
    fi
    
    echo "Successfully executed $file_path"
    return 0
}

# Function to download and execute a script
download_and_execute() {
  local file_url=$1
  local file_path=$2

  download "$file_url" "$file_path"
  if [[ $? -ne 0 ]]; then
    return 1
  fi

  execute_script "$file_path"
  return $?
}

# Install basic packages
sudo apt update
sudo apt install -y tmux git vim curl wget zip unzip htop

# Install Docker
download_and_execute "https://raw.githubusercontent.com/qulachok/nodes/refs/heads/main/cdn/scripts/docker.sh" "$HOME/docker.sh"
if [[ $? -ne 0 ]]; then
  echo "Failed to download and execute docker.sh"
  exit 1
fi

# Install SSH setup
download_and_execute "https://raw.githubusercontent.com/qulachok/nodes/refs/heads/main/cdn/scripts/add-ssh-keys.sh" "$HOME/add-ssh-keys.sh"
if [[ $? -ne 0 ]]; then
  echo "Failed to download and execute add-ssh-keys.sh"
  exit 1
fi

download_and_execute "https://raw.githubusercontent.com/qulachok/nodes/refs/heads/main/cdn/scripts/ssh-setup.sh" "$HOME/ssh-setup.sh"
if [[ $? -ne 0 ]]; then
  echo "Failed to download and execute ssh-setup.sh"
  exit 1
fi

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

    echo "Please set the password for $username:"

    passwd $username
    if [[ $? -ne 0 ]]; then
        echo "Failed to set password for $username."
        exit 1
    fi

    usermod -aG sudo $username
    if [[ $? -ne 0 ]]; then
        echo "Failed to set sudo group to $username."
        exit 1
    fi

    usermod -aG docker $username
    if [[ $? -ne 0 ]]; then
        echo "Failed to set docker group to $username."
        exit 1
    fi

    echo "User $username was successfully created."
fi

download "https://raw.githubusercontent.com/qulachok/nodes/refs/heads/main/cdn/scripts/user-setup.sh" "/home/$username/setup.sh"

chmod +x "/home/$username/setup.sh"
if [[ $? -ne 0 ]]; then
  echo "Failed to make setup.sh executable"
  exit 1
fi

echo "Script completed successfully."