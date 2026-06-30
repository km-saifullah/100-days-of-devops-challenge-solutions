```bash
#!/bin/bash

set -e

PORT=3003

echo "=========================================="
echo " Apache Recovery Script"
echo "=========================================="

#-------------------------------------------------------
# Verify Root Privileges
#-------------------------------------------------------
if [[ $EUID -ne 0 ]]; then
    echo "Please run this script as root."
    exit 1
fi

#-------------------------------------------------------
# Backup Sendmail Configuration
#-------------------------------------------------------
echo "[1/7] Creating backup..."

if [[ ! -f /etc/mail/sendmail.mc.bak ]]; then
    cp /etc/mail/sendmail.mc /etc/mail/sendmail.mc.bak
fi

#-------------------------------------------------------
# Resolve Sendmail Port Conflict
#-------------------------------------------------------
echo "[2/7] Checking Sendmail..."

if grep -q "Port=$PORT" /etc/mail/sendmail.mc; then

    echo "Port conflict detected."

    sed -i "s/Port=$PORT/Port=smtp/g" /etc/mail/sendmail.mc

    cd /etc/mail
    make

    systemctl restart sendmail

    echo "Sendmail configuration updated."

else

    echo "No Sendmail conflict detected."

fi

#-------------------------------------------------------
# Configure Apache
#-------------------------------------------------------
echo "[3/7] Configuring Apache..."

sed -i "s/^Listen.*/Listen $PORT/" /etc/httpd/conf/httpd.conf

#-------------------------------------------------------
# SELinux Configuration
#-------------------------------------------------------
echo "[4/7] Configuring SELinux..."

if command -v semanage >/dev/null 2>&1; then

    semanage port -a -t http_port_t -p tcp $PORT 2>/dev/null || \
    semanage port -m -t http_port_t -p tcp $PORT 2>/dev/null || true

fi

#-------------------------------------------------------
# Start Apache
#-------------------------------------------------------
echo "[5/7] Starting Apache..."

systemctl enable httpd >/dev/null 2>&1
systemctl restart httpd

#-------------------------------------------------------
# Verification
#-------------------------------------------------------
echo "[6/7] Apache Status"

systemctl --no-pager status httpd | head -10

echo

echo "[7/7] Listening Ports"

ss -tlnp | grep "$PORT"

echo

echo "=========================================="
echo "Apache is running successfully on port $PORT"
echo "=========================================="
```
