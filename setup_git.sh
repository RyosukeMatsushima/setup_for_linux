#!/bin/bash

# Set the user email and name for Git
read -p "Enter your GitHub email address: " email
git config --global user.email "$email"

# Prompt for the user name associated with GitHub account
read -p "Enter your GitHub username: " username
git config --global user.name "$username"


# Set nvim as the default editor for Git
git config --global core.editor "nvim"

# Confirm the change
echo "Git default editor set to nvim:"
git config --global core.editor

