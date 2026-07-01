```bash
#!/bin/bash

# =====================================================
# Configure Nginx with SSL
# =====================================================

set -e

echo "========================================="
echo " Nginx SSL Configuration Script"
echo "========================================="

#-------------------------------------------------------
# Root Check
#-------------------------------------------------------
if [[ $EUID -ne 0 ]]; then
    echo "Please run this script as root."
    exit 1
fi

#-------------------------------------------------------
# Install Nginx
#-------------------------------------------------------
echo "[1/7] Installing Nginx..."

yum install -y nginx

#-------------------------------------------------------
# Configure SSL
#-------------------------------------------------------
echo "[2/7] Configuring SSL..."

mkdir -p /etc/nginx/ssl

mv -f /tmp/nautilus.crt /etc/nginx/ssl/
mv -f /tmp/nautilus.key /etc/nginx/ssl/

chmod 644 /etc/nginx/ssl/nautilus.crt
chmod 600 /etc/nginx/ssl/nautilus.key

#-------------------------------------------------------
# Configure Nginx
#-------------------------------------------------------
echo "[3/7] Creating HTTPS virtual host..."

cat > /etc/nginx/conf.d/default.conf <<EOF
# For more information on configuration, see:
#   http://nginx.org/en/docs/

user nginx;
worker_processes auto;

error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {

    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    access_log /var/log/nginx/access.log main;

    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 4096;

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    #
    # HTTP Server (optional)
    #
    server {
        listen 80;
        listen [::]:80;
        server_name stapp02;

        return 301 https://$host$request_uri;
    }

    #
    # HTTPS Server
    #
    server {

        listen 443 ssl;
        listen [::]:443 ssl;

        server_name stapp02;

        root /usr/share/nginx/html;
        index index.html;

        ssl_certificate     /etc/nginx/ssl/nautilus.crt;
        ssl_certificate_key /etc/nginx/ssl/nautilus.key;

        ssl_session_cache shared:SSL:1m;
        ssl_session_timeout 10m;
        ssl_ciphers PROFILE=SYSTEM;
        ssl_prefer_server_ciphers on;

        location / {
            try_files $uri $uri/ =404;
        }

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }
}
```
EOF

#-------------------------------------------------------
# Create Web Page
#-------------------------------------------------------
echo "[4/7] Creating index page..."

echo "Welcome!" > /usr/share/nginx/html/index.html

#-------------------------------------------------------
# Validate Configuration
#-------------------------------------------------------
echo "[5/7] Testing configuration..."

nginx -t

#-------------------------------------------------------
# Start Nginx
#-------------------------------------------------------
echo "[6/7] Starting Nginx..."

systemctl enable nginx >/dev/null 2>&1
systemctl restart nginx

#-------------------------------------------------------
# Verification
#-------------------------------------------------------
echo "[7/7] Verification"

systemctl --no-pager status nginx | head -10

curl -k https://localhost/

echo
echo "========================================="
echo "Nginx configured successfully."
echo "========================================="
```
