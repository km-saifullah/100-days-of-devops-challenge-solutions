#!/bin/bash

set -e

DB_USER="kodekloud_roy"
DB_PASSWORD="8FmzjvFU6S"
DB_NAME="kodekloud_db3"

echo "=========================================="
echo " PostgreSQL Database Configuration"
echo "=========================================="

if [[ $EUID -ne 0 ]]; then
    echo "Please run this script as root."
    exit 1
fi

echo
echo "[1/3] Creating PostgreSQL user..."

sudo -u postgres psql <<EOF
CREATE USER ${DB_USER} WITH PASSWORD '${DB_PASSWORD}';
EOF

echo
echo "[2/3] Creating database..."

sudo -u postgres psql <<EOF
CREATE DATABASE ${DB_NAME};
EOF

echo
echo "[3/3] Granting privileges..."

sudo -u postgres psql <<EOF
GRANT ALL PRIVILEGES ON DATABASE ${DB_NAME} TO ${DB_USER};
EOF

echo
echo "=========================================="
echo " Configuration Completed Successfully"
echo "=========================================="

echo
echo "Database : ${DB_NAME}"
echo "User     : ${DB_USER}"
echo
