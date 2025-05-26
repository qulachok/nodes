#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Install basic packages
sudo apt update
sudo apt install -y tmux git vim curl wget zip unzip htop openssh-server ssh

# Import common functions
. <(wget -qO- https://raw.githubusercontent.com/qulachok/nodes/refs/heads/main/cdn/scripts/common.sh)

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

download "https://raw.githubusercontent.com/qulachok/nodes/refs/heads/main/cdn/scripts/setup-user.sh" "/home/$username/setup.sh"

chmod +x "/home/$username/setup.sh"
if [[ $? -ne 0 ]]; then
  echo "Failed to make setup.sh executable"
  exit 1
fi

echo "Script completed successfully."

echo "Please run the following command to switch to the new user:"
echo "<---->"
echo "su - $username"
echo "<---->"
echo "bash ~/setup.sh"
echo "<---->"