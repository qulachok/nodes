#!/bin/bash

# Import common functions
. <(wget -qO- https://raw.githubusercontent.com/qulachok/nodes/refs/heads/main/cdn/scripts/common.sh)

# Install SSH setup
download_and_execute "https://raw.githubusercontent.com/qulachok/nodes/refs/heads/main/cdn/scripts/add-ssh-keys.sh" "$HOME/add-ssh-keys.sh"
if [[ $? -ne 0 ]]; then
  echo "Failed to download and execute add-ssh-keys.sh"
  exit 1
fi

echo "Script completed successfully."