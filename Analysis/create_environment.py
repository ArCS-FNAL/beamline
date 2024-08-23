#!/bin/bash

# Script to create a Python virtual environment and install packages

# Define the directory for the virtual environment
ENV_DIR="myenv"

# Create a virtual environment
python3 -m venv $ENV_DIR

# Activate the virtual environment
source $ENV_DIR/bin/activate

# Upgrade pip to the latest version
pip install --upgrade pip

# List of packages to install
PACKAGES=(
    "numpy"
    "pandas"
    "requests"
    "flask"
)

# Install packages
pip install "${PACKAGES[@]}"

# Deactivate the virtual environment
deactivate

echo "Virtual environment setup complete!"
