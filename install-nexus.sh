#!/bin/bash

# Script to install Nexus Repository OSS on Ubuntu Server
# Run as root or with sudo

set -e

echo "[Step 1] Updating system..."
sudo apt-get update -y
sudo apt-get upgrade -y

echo "[Step 2] Installing Java (OpenJDK 17)..."
sudo apt-get install -y openjdk-17-jdk

echo "[Step 3] Creating nexus user and group..."
sudo useradd -M -d /opt/nexus -s /bin/bash nexus || true

echo "[Step 4] Downloading Nexus OSS..."
cd /opt
sudo wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz -O nexus.tar.gz

echo "[Step 5] Extracting Nexus..."
sudo tar -xvzf nexus.tar.gz
sudo rm nexus.tar.gz
sudo mv nexus-3* nexus

echo "[Step 6] Setting permissions..."
sudo chown -R nexus:nexus /opt/nexus
sudo chown -R nexus:nexus /opt/sonatype-work

echo "[Step 7] Configuring Nexus to run as nexus user..."
echo 'run_as_user="nexus"' | sudo tee /opt/nexus/bin/nexus.rc

echo "[Step 8] Creating systemd service file for Nexus..."
sudo tee /etc/systemd/system/nexus.service > /dev/null <<EOL
[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
ExecStart=/opt/nexus/bin/nexus start
ExecStop=/opt/nexus/bin/nexus stop
User=nexus
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOL

echo "[Step 9] Enabling and starting Nexus service..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable nexus
sudo systemctl start nexus

echo ""
echo "[✔] Nexus installation completed!"
echo "Access Nexus Repository at: http://<your_server_ip>:8081"
echo "To get the initial admin password, run:"
echo "  sudo cat /opt/sonatype-work/nexus3/admin.password"
