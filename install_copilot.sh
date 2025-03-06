#!/bin/bash


# for node install
sudo apt-get install zip unzip

# Download and install fnm:
curl -o- https://fnm.vercel.app/install | bash

source /home/r/.bashrc

# Download and install Node.js:
fnm install 22

# Verify the Node.js version:
node -v # Should print "v22.14.0".

# Verify npm version:
npm -v # Should print "10.9.2".


git clone https://github.com/github/copilot.vim.git \
  ~/.config/nvim/pack/github/start/copilot.vim

# for Copilot setup
sudo apt update && sudo apt install xdg-utils


echo ""
echo "****finish install****"
echo "open nvim and run :Copilot setup"
echo "you might need restart your computer to setup"
