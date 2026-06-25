#!/bin/bash

# Check MariaDB service status
systemctl status mariadb -l

# Check logs
journalctl -xeu mariadb

# Check MariaDB data directory
echo "Checking MariaDB data directory..."
ls -la /var/lib/mysql

# Remove unwanted files from the data directory
rm -rf /var/lib/mysql/*

# Initialize MariaDB database
mariadb-install-db --user=mysql --datadir=/var/lib/mysql

# Set correct ownership
chown -R mysql:mysql /var/lib/mysql

# Start MariaDB service
systemctl start mariadb

# Enable the MariaDB
systemctl enable mariadb

# Verify service status
systemctl is-active mariadb

# Check the status now
systemctl status mariadb