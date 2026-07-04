#!/bin/bash

set -e

DB_NAME="kodekloud_db2"
DB_USER="kodekloud_cap"
DB_PASSWORD="TmPcZjtRQx"

echo "=========================================="
echo " MariaDB Configuration"
echo "=========================================="

if [[ $EUID -ne 0 ]]; then
    echo "Please run this script as root."
    exit 1
fi

echo
echo "[1/5] Installing MariaDB..."

yum install -y mariadb-server

echo
echo "[2/5] Starting MariaDB..."

systemctl enable mariadb
systemctl start mariadb

echo
echo "[3/5] Creating database..."

mysql -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME};"

echo
echo "[4/5] Creating database user..."

mysql -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';"

echo
echo "[5/5] Granting privileges..."

mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost'; FLUSH PRIVILEGES;"

echo
echo "=========================================="
echo " MariaDB Configuration Completed"
echo "=========================================="

echo
echo "Database : ${DB_NAME}"
echo "User     : ${DB_USER}"