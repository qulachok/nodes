#!/bin/bash

ssh_path="$HOME/.ssh"
public_key="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPvnhH9Sdm9vOHowo3TmCp8ourPaSuoDaG2fSERXQRVz nodes@qula.dev"

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
  sudo systemctl restart sshd
else
  echo "Public access key is not installed, exiting..."
  exit 1
fi