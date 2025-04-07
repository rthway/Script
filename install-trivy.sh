#!/bin/bash

# Script to install Trivy vulnerability scanner on Ubuntu

set -e

echo "[Step 1] Updating system..."
sudo apt-get update -y

echo "[Step 2] Installing required packages..."
sudo apt-get install -y wget apt-transport-https gnupg lsb-release

echo "[Step 3] Adding Trivy GPG key..."
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo gpg --dearmor -o /usr/share/keyrings/trivy.gpg

echo "[Step 4] Adding Trivy repo to apt sources..."
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/trivy.list > /dev/null

echo "[Step 5] Updating package list..."
sudo apt-get update -y

echo "[Step 6] Installing Trivy..."
sudo apt-get install -y trivy

echo "[✔] Trivy installation completed!"
echo "Example usage:"
echo "  trivy image nginx"
echo "  trivy fs /path/to/project"
echo "  trivy repo https://github.com/org/repo"
