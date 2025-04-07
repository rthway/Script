#!/bin/bash

# Docker cleanup script
# Cleans up unused containers, images, volumes, and networks

set -e

echo "[Step 1] Removing exited/stopped containers..."
docker container prune -f

echo "[Step 2] Removing dangling/unused images..."
docker image prune -f

echo "[Step 3] Removing unused volumes..."
docker volume prune -f

echo "[Step 4] Removing unused networks..."
docker network prune -f

echo "[Step 5] Removing all unused images, containers, volumes, and networks (safe full cleanup)..."
docker system prune -f

echo ""
echo "[✔] Docker cleanup completed!"
docker system df
