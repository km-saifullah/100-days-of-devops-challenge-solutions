#!/bin/bash

set -e

echo "========================================="
echo " Git Repository Clone"
echo "========================================="

echo "[1/4] Creating destination directory..."

mkdir -p /usr/src/kodekloudrepos

echo "[2/4] Cloning repository..."

git clone /opt/games.git /usr/src/kodekloudrepos/games

echo "[3/4] Verifying repository..."

cd /usr/src/kodekloudrepos/games

git status

echo "[4/4] Listing destination..."

ls -l /usr/src/kodekloudrepos

echo
echo "========================================="
echo " Repository Cloned Successfully"
echo "========================================="