#!/bin/bash

# ============================================
# Apache 8082 Troubleshooting Script
# ============================================

set -e

PORT=8082

echo "==========================================="
echo " Apache Troubleshooting (Port $PORT)"
echo "==========================================="

#------------------------------------------------
# Root User Check
#------------------------------------------------
if [[ $EUID -ne 0 ]]; then
    echo "Please run this script as root or with sudo."
    exit 1
fi

#------------------------------------------------
# Backup Sendmail Configuration
#------------------------------------------------
echo "[1/7] Checking Sendmail configuration..."

if [[ ! -f /etc/mail/sendmail.mc.bak ]]; then
    cp /etc/mail/sendmail.mc /etc/mail/sendmail.mc.bak
    echo "Backup created."
fi

#------------------------------------------------
# Resolve Sendmail Port Conflict
#------------------------------------------------
if grep -q "Port=$PORT" /etc/mail/sendmail.mc; then

    echo "Sendmail is using port $PORT."

    sed -i "s/Port=$PORT/Port=smtp/g" /etc/mail/sendmail.mc

    cd /etc/mail
    make

    systemctl restart sendmail

    echo "Sendmail port conflict resolved."

else

    echo "No Sendmail conflict found."

fi

#------------------------------------------------
# Start Apache
#------------------------------------------------
echo
echo "[2/7] Starting Apache..."

systemctl enable httpd >/dev/null 2>&1
systemctl restart httpd

#------------------------------------------------
# Firewall Rule
#------------------------------------------------
echo
echo "[3/7] Checking Firewall..."

if ! iptables -C INPUT -p tcp --dport $PORT -j ACCEPT 2>/dev/null; then

    iptables -I INPUT -p tcp --dport $PORT -j ACCEPT
    echo "Firewall rule added."

else

    echo "Firewall rule already exists."

fi

#------------------------------------------------
# Verify Apache
#------------------------------------------------
echo
echo "[4/7] Apache Status"

systemctl --no-pager status httpd | head -10

#------------------------------------------------
# Verify Listening Port
#------------------------------------------------
echo
echo "[5/7] Listening Port"

ss -tlnp | grep "$PORT"

#------------------------------------------------
# Local Test
#------------------------------------------------
echo
echo "[6/7] Testing Apache..."

curl -I http://localhost:$PORT

#------------------------------------------------
# Completed
#------------------------------------------------
echo
echo "[7/7] Completed Successfully"

echo
echo "Run the following command from the Jump Host:"
echo
echo "curl http://stapp01:$PORT"
