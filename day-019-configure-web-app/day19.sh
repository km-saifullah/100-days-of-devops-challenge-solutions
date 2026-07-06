#!/bin/bash

set -e

HTTP_PORT=5004

echo "========================================="
echo " Static Website Deployment"
echo "========================================="

if [[ $EUID -ne 0 ]]; then
    echo "Please run as root."
    exit 1
fi

echo
echo "[1/7] Installing Apache..."

yum install -y httpd

echo
echo "[2/7] Configuring Apache Port..."

sed -i "s/^Listen .*/Listen ${HTTP_PORT}/" /etc/httpd/conf/httpd.conf

echo
echo "[3/7] Creating Website Directories..."

mkdir -p /var/www/html/official
mkdir -p /var/www/html/cluster

echo
echo "[4/7] Copying Website Files..."

cp -r /tmp/official/* /var/www/html/official/
cp -r /tmp/cluster/* /var/www/html/cluster/

echo
echo "[5/7] Setting Permissions..."

chown -R apache:apache /var/www/html/official
chown -R apache:apache /var/www/html/cluster

chmod -R 755 /var/www/html/official
chmod -R 755 /var/www/html/cluster

echo
echo "[6/7] Starting Apache..."

systemctl enable httpd >/dev/null 2>&1
systemctl restart httpd

echo
echo "[7/7] Verifying..."

curl http://localhost:${HTTP_PORT}/official/
curl http://localhost:${HTTP_PORT}/cluster/

echo
echo "========================================="
echo " Deployment Completed Successfully"
echo "========================================="