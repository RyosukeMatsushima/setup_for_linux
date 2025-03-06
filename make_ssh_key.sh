#!/bin/bash

# Prompt for the email address associated with GitHub account
read -p "Enter your GitHub email address: " email

# Generate a new SSH key with the provided email
echo "Generating SSH key..."
ssh-keygen -t rsa -b 4096 -C "$email" -f ~/.ssh/id_rsa -N ""

# Start the SSH agent
echo "Starting SSH agent..."
eval "$(ssh-agent -s)"

# Add the SSH private key to the agent
echo "Adding SSH key to the agent..."
ssh-add ~/.ssh/id_rsa

# Display the SSH public key to copy to GitHub
echo "Copy the following SSH public key to GitHub:"
cat ~/.ssh/id_rsa.pub

echo "To add the key to GitHub, visit https://github.com/settings/keys and click on 'New SSH key'."
echo "Paste the public key there and give it a title."
echo "Then, test the SSH connection with: ssh -T git@github.com"


