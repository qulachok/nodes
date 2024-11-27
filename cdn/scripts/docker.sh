#! /bin/bash

sudo apt-get update

# Install Docker
if ! command -v docker &> /dev/null; then
  sudo apt-get install ca-certificates curl
  curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh
  sudo docker run hello-world
  echo -e "\e[1m\e[32mInstalled docker\e[0m"
else
  echo -e "\e[1m\e[32mDocker is already installed\e[0m"
fi

if ! command -v docker-compose &> /dev/null; then
  sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose
  echo -e "\e[1m\e[32mInstalled docker-compose\e[0m"
else
  echo -e "\e[1m\e[32mdocker-compose is already installed\e[0m"
fi