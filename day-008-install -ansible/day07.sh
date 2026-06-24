#!/bin/bash

# Install Ansible 4.9.0
pip3 install ansible==4.9.0

# Find the installationn Path
which ansible

# Make Ansible globally accessible
ln -sf $(which ansible) /usr/bin/ansible

# Verify installation
ansible --version