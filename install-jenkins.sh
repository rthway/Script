#!/bin/bash

# Script to install Jenkins on Ubuntu

set -e

echo "[Step 1] Updating system..."
sudo apt-get update -y
sudo apt-get upgrade -y

echo "[Step 2] Installing Java (OpenJDK 17)..."
sudo apt install -y openjdk-17-jdk

echo "[Step 3] Adding Jenkins GPG key and repository..."
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "[Step 4] Updating package list..."
sudo apt-get update -y

echo "[Step 5] Installing Jenkins..."
sudo apt-get install -y jenkins

echo "[Step 6] Enabling and starting Jenkins..."
sudo systemctl enable jenkins
sudo systemctl start jenkins

echo "[Step 7] Checking Jenkins status..."
sudo systemctl status jenkins | grep Active

echo ""
echo "[✔] Jenkins installation completed!"
echo "Access Jenkins at: http://<your_server_ip>:8080"
echo "To get the initial admin password, run:"
echo "  sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
