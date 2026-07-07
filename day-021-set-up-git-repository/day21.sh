#!/bin/bash

set -e

echo "========================================="
echo " Git Repository Setup"
echo "========================================="

echo "[1/3] Installing Git..."

yum install -y git

echo "[2/3] Creating Bare Repository..."

git init --bare /opt/official.git

echo "[3/3] Verification..."

git --version

ls -ld /opt/official.git

echo

echo "Repository Contents:"
ls /opt/official.git

echo
echo "========================================="
echo " Git Repository Created Successfully"
echo "========================================="