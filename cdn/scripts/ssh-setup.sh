#!/bin/bash

ssh_path="$HOME/.ssh"
public_key="$SSH_PUBLIC_KEY"

if [ ! -f "$ssh_path/authorized_keys" ]; then
  echo "No authorized_keys file found in $ssh_path, exiting..."
  exit 1
fi

if grep -q "$public_key" "$ssh_path/authorized_keys"; then
  echo "Public access key is installed..."
  sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
  sudo sed -i 's/#PasswordAuthentication no/PasswordAuthentication no/g' /etc/ssh/sshd_config
  sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
  sudo sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config

  # Restart SSH service
  sudo systemctl restart sshd
  if [[ $? -ne 0 ]]; then
    echo "Failed to restart SSH service"
  fi
  echo "Successfully restarted SSH service"
else
  echo "Public access key is not installed, exiting..."
  exit 1
fi
