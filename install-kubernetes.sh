#!/bin/bash

# Script to install Kubernetes on Ubuntu Server
# This script installs kubeadm, kubelet, and kubectl

set -e

echo "[Step 1] Updating system..."
sudo apt-get update -y
sudo apt-get upgrade -y

echo "[Step 2] Disabling swap..."
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

echo "[Step 3] Installing transport-https and curl..."
sudo apt-get install -y apt-transport-https ca-certificates curl

echo "[Step 4] Adding Kubernetes GPG key..."
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "[Step 5] Adding Kubernetes apt repository..."
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] \
https://apt.kubernetes.io/ kubernetes-xenial main" | \
sudo tee /etc/apt/sources.list.d/kubernetes.list

echo "[Step 6] Updating package list..."
sudo apt-get update -y

echo "[Step 7] Installing kubelet, kubeadm, and kubectl..."
sudo apt-get install -y kubelet kubeadm kubectl

echo "[Step 8] Holding versions to prevent unintended upgrades..."
sudo apt-mark hold kubelet kubeadm kubectl

echo "[Step 9] Enabling kubelet service..."
sudo systemctl enable kubelet

echo "[Kubernetes Installation Completed]"
echo "You can now initialize the cluster using:"
echo "  sudo kubeadm init  (for master node)"
echo "Or join the cluster using:"
echo "  sudo kubeadm join <command from master>  (for worker node)"
