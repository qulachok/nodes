#! /bin/bash

sudo apt-get update

if ! command -v fnm &> /dev/null; then
  curl -fsSL https://fnm.vercel.app/install | bash
  sed -i 's/eval "`fnm env`"/eval "$(fnm env --use-on-cd --shell bash)"/g' ~/.bashrc
  echo -e "\e[1m\e[32mInstalled fnm\e[0m"
else
  echo -e "\e[1m\e[32mfnm is already installed\e[0m"
fi
