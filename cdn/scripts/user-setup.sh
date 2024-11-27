#!/bin/bash

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

# Install SSH setup
download_and_execute "https://raw.githubusercontent.com/qulachok/nodes/refs/heads/main/cdn/scripts/add-ssh-keys.sh" "$HOME/add-ssh-keys.sh"
if [[ $? -ne 0 ]]; then
  echo "Failed to download and execute add-ssh-keys.sh"
  exit 1
fi

echo "Script completed successfully."