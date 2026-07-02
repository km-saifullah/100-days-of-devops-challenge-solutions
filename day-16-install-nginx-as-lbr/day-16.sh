```bash
#!/bin/bash

# ==========================================================
# Configure Nginx Load Balancer
# Server : stlb01
# ==========================================================

set -e

BACKEND_PORT=8085

echo "========================================="
echo " Configuring Nginx Load Balancer"
echo "========================================="

#-----------------------------------------------------------
# Check Root User
#-----------------------------------------------------------
if [[ $EUID -ne 0 ]]; then
    echo "Please run this script as root."
    exit 1
fi

#-----------------------------------------------------------
# Install Nginx
#-----------------------------------------------------------
echo
echo "[1/6] Installing Nginx..."

yum install -y nginx

#-----------------------------------------------------------
# Backup Existing Configuration
#-----------------------------------------------------------
echo
echo "[2/6] Creating Backup..."

cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak.$(date +%F-%H%M%S)

#-----------------------------------------------------------
# Configure Load Balancer
#-----------------------------------------------------------
echo
echo "[3/6] Writing nginx.conf..."

cat > /etc/nginx/nginx.conf <<EOF
user nginx;
worker_processes auto;

error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {

    log_format main '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                    '\$status \$body_bytes_sent "\$http_referer" '
                    '"\$http_user_agent" "\$http_x_forwarded_for"';

    access_log /var/log/nginx/access.log main;

    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    upstream app_servers {
        server stapp01:${BACKEND_PORT};
        server stapp02:${BACKEND_PORT};
        server stapp03:${BACKEND_PORT};
    }

    server {

        listen 80;
        listen [::]:80;

        server_name _;

        location / {

            proxy_pass http://app_servers;

            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;

        }
    }
}
EOF

#-----------------------------------------------------------
# Validate Configuration
#-----------------------------------------------------------
echo
echo "[4/6] Validating Configuration..."

nginx -t

#-----------------------------------------------------------
# Enable and Restart Nginx
#-----------------------------------------------------------
echo
echo "[5/6] Starting Nginx..."

systemctl enable nginx >/dev/null 2>&1
systemctl restart nginx

#-----------------------------------------------------------
# Verification
#-----------------------------------------------------------
echo
echo "[6/6] Verification"

systemctl --no-pager status nginx | head -10

echo
echo "Testing Load Balancer..."

curl http://localhost

echo
echo "========================================="
echo " Load Balancer Configured Successfully"
echo "========================================="
echo
echo "Now verify from the Jump Host:"
echo
echo "curl http://stlb01"
echo
```
