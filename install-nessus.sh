#!/bin/bash

# Script to install Tenable Nessus on Ubuntu Server

set -e

# Step 1: Download Nessus package
echo "[Step 1] Downloading Nessus..."
cd /tmp
wget https://www.tenable.com/downloads/api/v1/public/pages/nessus/downloads/13448/download?i_agree_to_tenable_license_agreement=true -O nessus.deb

# Step 2: Installing Nessus package
echo "[Step 2] Installing Nessus..."
sudo dpkg -i nessus.deb

# Step 3: Install dependencies if needed
echo "[Step 3] Installing dependencies..."
sudo apt-get install -f -y

# Step 4: Starting Nessus service
echo "[Step 4] Starting Nessus service..."
sudo systemctl start nessusd
sudo systemctl enable nessusd

# Step 5: Check the status of Nessus service
echo "[Step 5] Checking Nessus service status..."
sudo systemctl status nessusd | grep Active

echo ""
echo "[✔] Nessus installation completed!"
echo "Access Nessus at: https://<your_server_ip>:8834"
echo "Complete setup via web interface"
