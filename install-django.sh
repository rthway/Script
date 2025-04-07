#!/bin/bash

# Script to install Django on Ubuntu

set -e

# Step 1: Update system packages
echo "[Step 1] Updating system..."
sudo apt-get update -y
sudo apt-get upgrade -y

# Step 2: Install Python and pip (if not installed already)
echo "[Step 2] Installing Python and pip..."
sudo apt-get install -y python3 python3-pip python3-venv

# Step 3: Install virtualenv (optional, for better project isolation)
echo "[Step 3] Installing virtualenv..."
sudo pip3 install virtualenv

# Step 4: Create a project directory (optional)
echo "[Step 4] Creating Django project directory..."
mkdir -p ~/my_django_project
cd ~/my_django_project

# Step 5: Create a virtual environment
echo "[Step 5] Creating virtual environment..."
python3 -m venv venv

# Step 6: Activate the virtual environment
echo "[Step 6] Activating the virtual environment..."
source venv/bin/activate

# Step 7: Install Django using pip
echo "[Step 7] Installing Django..."
pip install django

# Step 8: Verify the Django installation
echo "[Step 8] Verifying Django installation..."
django-admin --version

# Step 9: Start a new Django project (optional)
echo "[Step 9] Starting new Django project..."
django-admin startproject myproject .

echo "[✔] Django installation completed!"
echo "Your Django project has been created in ~/my_django_project."
echo "To start the Django server, use: python manage.py runserver"
