#!/bin/bash

# Script to install Grafana on Ubuntu

set -e

echo "[Step 1] Updating system..."
sudo apt-get update -y
sudo apt-get upgrade -y

echo "[Step 2] Installing dependencies..."
sudo apt-get install -y software-properties-common

echo "[Step 3] Adding Grafana repository..."
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"

echo "[Step 4] Adding Grafana GPG key..."
sudo apt-get install -y gnupg
sudo curl https://packages.grafana.com/gpg.key | sudo apt-key add -

echo "[Step 5] Installing Grafana..."
sudo apt-get update -y
sudo apt-get install -y grafana

echo "[Step 6] Enabling and starting Grafana service..."
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
sudo ufw allow 3000


echo "[Step 7] Checking Grafana status..."
sudo systemctl status grafana-server | grep Active

echo ""
echo "[✔] Grafana installation completed!"
echo "Access Grafana at: http://<your_server_ip>:3000"
echo "Default login: admin / admin"
