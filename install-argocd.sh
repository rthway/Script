#!/bin/bash

# Script to install Argo CD on Ubuntu Server

set -e

echo "[Step 1] Update system..."
sudo apt-get update -y

echo "[Step 2] Installing dependencies..."
sudo apt-get install -y curl apt-transport-https

echo "[Step 3] Install kubectl (if not installed already)..."
if ! command -v kubectl &>/dev/null; then
  echo "kubectl is not installed. Installing..."
  sudo apt-get install -y kubectl
fi

echo "[Step 4] Install Argo CD CLI..."
curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v2.6.0/argocd-linux-amd64
sudo chmod +x /usr/local/bin/argocd

echo "[Step 5] Verify Argo CD CLI installation..."
argocd version

echo "[Step 6] Install Argo CD on Kubernetes cluster..."
kubectl create namespace argocd

# Install Argo CD via Helm
echo "[Step 7] Adding Argo CD Helm repository..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "[Step 8] Wait for Argo CD components to be deployed..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=300s

echo "[Step 9] Exposing Argo CD API server..."
kubectl expose service argocd-server --type=LoadBalancer --name=argocd-server -n argocd

echo "[Step 10] Retrieving Argo CD initial password..."
ARGO_CD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o go-template='{{.data.password | base64decode}}')

echo ""
echo "[✔] Argo CD installation completed!"
echo "Access Argo CD UI at: https://<your_server_ip>:80"
echo "Default login: admin / $ARGO_CD_PASSWORD"
