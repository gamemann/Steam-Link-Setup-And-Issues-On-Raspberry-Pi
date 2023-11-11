#!/bin/bash
# Install Git if not already installed (doesn't come with LITE version by default).
echo "Installing Git if not already installed..."
sudo apt install -y git

# Install Raspberry Pi kernel headers + DKMS
echo "Installing Raspberry Pi kernel headers + DKMS..."
sudo apt install -y dkms raspberrypi-kernel-headers

# Clone xpadneo GitHub repository
echo "Cloning xpadneo..."
git clone https://github.com/atar-axis/xpadneo.git

# Change directory to cloned xpadneo directory
echo "Changing directory to xpadneo/..."
cd xpadneo

# Install
echo "Installing xpadneo..."
sudo ./install.sh
