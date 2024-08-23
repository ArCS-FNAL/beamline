#!/bin/bash

# Script to create a Python virtual environment and install packages

# Define the directory for the virtual environment
ENV_DIR="analysis-env"

echo "Creating environment $ENV_DIR"

# Set up python
source /cvmfs/larsoft.opensciencegrid.org/setup_larsoft.sh
source /cvmfs/fermilab.opensciencegrid.org/products/common/etc/setups.sh
setup python v3_9_15

# Create a virtual environment
python3 -m venv $ENV_DIR

# Activate the virtual environment
source $ENV_DIR/bin/activate

# Upgrade pip to the latest version
pip install --upgrade pip

# Install packages
pip install -r requirements.txt

# Deactivate the virtual environment
deactivate

echo "Virtual environment setup complete!"
