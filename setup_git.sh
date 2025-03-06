#!/bin/bash

# Set the user email and name for Git
read -p "Enter your GitHub email address: " email
git config --global user.email "$email"

# Prompt for the user name associated with GitHub account
read -p "Enter your GitHub username: " username
git config --global user.name "$username"
