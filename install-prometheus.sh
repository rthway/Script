#!/bin/bash

# Script to install Prometheus on Ubuntu
# Default port: 9090

set -e

PROM_VERSION="2.52.0"
USER="prometheus"

echo "[Step 1] Creating prometheus user..."
sudo useradd --no-create-home --shell /bin/false $USER || true

echo "[Step 2] Creating directories..."
sudo mkdir -p /etc/prometheus /var/lib/prometheus

echo "[Step 3] Downloading Prometheus $PROM_VERSION..."
cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v$PROM_VERSION/prometheus-$PROM_VERSION.linux-amd64.tar.gz

echo "[Step 4] Extracting Prometheus..."
tar xvf prometheus-$PROM_VERSION.linux-amd64.tar.gz
cd prometheus-$PROM_VERSION.linux-amd64

echo "[Step 5] Moving binaries..."
sudo cp prometheus promtool /usr/local/bin/
sudo cp -r consoles console_libraries /etc/prometheus
sudo cp prometheus.yml /etc/prometheus

echo "[Step 6] Setting permissions..."
sudo chown -R $USER:$USER /etc/prometheus /var/lib/prometheus
sudo chown $USER:$USER /usr/local/bin/prometheus /usr/local/bin/promtool

echo "[Step 7] Creating systemd service..."
sudo tee /etc/systemd/system/prometheus.service > /dev/null <<EOL
[Unit]
Description=Prometheus Monitoring
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus/ \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOL

echo "[Step 8] Reloading and starting Prometheus service..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus

echo ""
echo "[✔] Prometheus $PROM_VERSION installed and running!"
echo "Access Prometheus at: http://<your_server_ip>:9090"
