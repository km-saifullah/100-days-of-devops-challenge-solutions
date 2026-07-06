#!/bin/bash

set -e

echo "========================================="
echo " Deploying PHP Application with Nginx"
echo "========================================="

# Install required packages
echo "[1/7] Installing Nginx and PHP-FPM..."

yum install -y nginx 

sudo dnf module reset php -y
sudo dnf module enable php:8.1 -y
sudo dnf install -y nginx php php-fpm php-cli

# Create socket directory
echo "[2/7] Creating PHP socket directory..."

mkdir -p /var/run/php-fpm

# Configure PHP-FPM
echo "[3/7] Configuring PHP-FPM..."

cp /etc/php-fpm.d/www.conf /etc/php-fpm.d/www.conf.bak

sed -i 's|^listen = .*|listen = /var/run/php-fpm/default.sock|' /etc/php-fpm.d/www.conf
sed -i 's|^;listen.owner =.*|listen.owner = nginx|' /etc/php-fpm.d/www.conf
sed -i 's|^;listen.group =.*|listen.group = nginx|' /etc/php-fpm.d/www.conf
sed -i 's|^;listen.mode =.*|listen.mode = 0660|' /etc/php-fpm.d/www.conf
sed -i 's|^user = .*|user = nginx|' /etc/php-fpm.d/www.conf
sed -i 's|^group = .*|group = nginx|' /etc/php-fpm.d/www.conf

# Backup nginx configuration
echo "[4/7] Configuring Nginx..."

cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak

cat >/etc/nginx/nginx.conf <<'EOF'
user nginx;
worker_processes auto;

error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {

    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    access_log /var/log/nginx/access.log;

    sendfile on;
    keepalive_timeout 65;

    server {

        listen 8094;
        listen [::]:8094;

        server_name _;

        root /var/www/html;
        index index.php index.html index.htm;

        location / {
            try_files $uri $uri/ =404;
        }

        location ~ \.php$ {

            include fastcgi_params;
            fastcgi_index index.php;
            fastcgi_pass unix:/var/run/php-fpm/default.sock;

            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        }
    }
}
EOF

# Validate configuration
echo "[5/7] Validating configuration..."

php-fpm -tt
nginx -t

# Enable services
echo "[6/7] Starting services..."

systemctl enable php-fpm
systemctl restart php-fpm

systemctl enable nginx
systemctl restart nginx

# Verification
echo "[7/7] Verification..."

netstat -tlnp | grep 8094 || true

echo
curl http://localhost:8094/index.php || true

echo
echo "========================================="
echo " Deployment Completed Successfully"
echo "========================================="
echo
echo "Now verify from Jump Host:"
echo
echo "curl http://stapp03:8094/index.php"
echo