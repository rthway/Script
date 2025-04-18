#!/bin/bash

# Exit on any error
set -e

echo "===== Updating Server ====="
sudo apt-get update -y && sudo apt-get upgrade -y

echo "===== Securing Server with Fail2Ban ====="
sudo apt-get install -y fail2ban
sudo systemctl start fail2ban
sudo systemctl enable fail2ban

echo "===== Installing Required Packages and Libraries ====="
sudo apt-get install -y python3-pip python3-dev libxml2-dev libxslt1-dev zlib1g-dev \
libsasl2-dev libldap2-dev build-essential libssl-dev libffi-dev libmysqlclient-dev \
libjpeg-dev libpq-dev libjpeg8-dev liblcms2-dev libblas-dev libatlas-base-dev npm git \
node-less python3-venv

sudo ln -sf /usr/bin/nodejs /usr/bin/node
sudo npm install -g less less-plugin-clean-css

echo "===== Installing PostgreSQL and Creating Odoo DB User ====="
sudo apt-get install -y postgresql
sudo -u postgres psql -c "CREATE ROLE odoo18 WITH CREATEDB LOGIN SUPERUSER PASSWORD '123456';"

echo "===== Creating Odoo System User ====="
sudo adduser --system --home=/opt/odoo18 --group odoo18

echo "===== Cloning Odoo 18 Community Edition ====="
sudo -u odoo18 -s /bin/bash -c "cd /opt/odoo18 && git clone https://www.github.com/odoo/odoo --depth 1 --branch 18.0 --single-branch ."

echo "===== Setting Up Python Virtual Environment ====="
sudo python3 -m venv /opt/odoo18/venv
source /opt/odoo18/venv/bin/activate
pip install wheel
pip install -r /opt/odoo18/requirements.txt
deactivate

echo "===== Installing wkhtmltopdf ====="
cd /tmp
wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.bionic_amd64.deb
wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb
sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb
sudo apt-get install -y xfonts-75dpi
sudo dpkg -i wkhtmltox_0.12.5-1.bionic_amd64.deb || sudo apt install -f -y

echo "===== Creating Odoo Config File ====="
cat <<EOF | sudo tee /etc/odoo18.conf > /dev/null
[options]
; This is the password that allows database operations:
; admin_passwd = admin
db_host = localhost
db_port = 5432
db_user = odoo18
db_password = 123456
addons_path = /opt/odoo18/addons
default_productivity_apps = True
logfile = /var/log/odoo/odoo18.log
EOF

sudo chown odoo18: /etc/odoo18.conf
sudo chmod 640 /etc/odoo18.conf

echo "===== Creating Log Directory ====="
sudo mkdir -p /var/log/odoo
sudo chown odoo18:root /var/log/odoo

echo "===== Creating systemd Service File ====="
cat <<EOF | sudo tee /etc/systemd/system/odoo18.service > /dev/null
[Unit]
Description=Odoo18
Documentation=http://www.odoo.com

[Service]
Type=simple
User=odoo18
ExecStart=/opt/odoo18/venv/bin/python3 /opt/odoo18/odoo-bin -c /etc/odoo18.conf

[Install]
WantedBy=default.target
EOF

sudo chmod 755 /etc/systemd/system/odoo18.service
sudo chown root: /etc/systemd/system/odoo18.service

echo "===== Enabling and Starting Odoo18 Service ====="
sudo systemctl daemon-reload
sudo systemctl start odoo18.service
sudo systemctl enable odoo18.service

echo "===== Odoo 18 Installation Complete! Visit your server IP to access Odoo. ====="
