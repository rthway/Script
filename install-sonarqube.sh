#!/bin/bash

# Script to install SonarQube on Ubuntu Server

set -e

echo "[Step 1] Update system..."
sudo apt update -y
sudo apt upgrade -y

echo "[Step 2] Install Java (OpenJDK 17)..."
sudo apt install -y openjdk-17-jdk

echo "[Step 3] Install PostgreSQL..."
sudo apt install -y postgresql postgresql-contrib

echo "[Step 4] Create SonarQube DB and user..."
sudo -u postgres psql <<EOF
CREATE USER sonar WITH ENCRYPTED PASSWORD 'sonar';
CREATE DATABASE sonarqube OWNER sonar;
GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonar;
EOF

echo "[Step 5] Downloading SonarQube..."
cd /opt
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.4.1.88267.zip -O sonarqube.zip
sudo apt install -y unzip
sudo unzip sonarqube.zip
sudo rm sonarqube.zip
sudo mv sonarqube-* sonarqube

echo "[Step 6] Create sonarqube user..."
sudo useradd -M -d /opt/sonarqube -s /bin/bash sonar
sudo chown -R sonar:sonar /opt/sonarqube

echo "[Step 7] Configure SonarQube to use PostgreSQL..."
sudo sed -i 's|#sonar.jdbc.username=|sonar.jdbc.username=sonar|' /opt/sonarqube/conf/sonar.properties
sudo sed -i 's|#sonar.jdbc.password=|sonar.jdbc.password=sonar|' /opt/sonarqube/conf/sonar.properties
echo "sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube" | sudo tee -a /opt/sonarqube/conf/sonar.properties > /dev/null

echo "[Step 8] Create systemd service for SonarQube..."
sudo tee /etc/systemd/system/sonarqube.service > /dev/null <<EOL
[Unit]
Description=SonarQube service
After=network.target

[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
User=sonar
Group=sonar
Restart=on-failure
LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
EOL

echo "[Step 9] Enable and start SonarQube service..."
sudo systemctl daemon-reload
sudo systemctl enable sonarqube
sudo systemctl start sonarqube

echo ""
echo "[✔] SonarQube installation completed!"
echo "Access it at: http://<your_server_ip>:9000"
echo "Default login: admin / admin"
