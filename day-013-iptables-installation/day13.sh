```bash
#!/bin/bash

# ============================================
# Secure Apache Port 5004
# ============================================

set -e

PORT=5004

echo "==========================================="
echo " Securing Apache Port $PORT"
echo "==========================================="

#--------------------------------------------
# Root Check
#--------------------------------------------
if [[ $EUID -ne 0 ]]; then
    echo "Run this script as root."
    exit 1
fi

#--------------------------------------------
# Install iptables
#--------------------------------------------
echo "[1/5] Installing iptables..."

yum install -y iptables iptables-services

#--------------------------------------------
# Detect Load Balancer IP
#--------------------------------------------
echo "[2/5] Detecting LBR IP..."

LBR_IP=$(getent hosts stlb01 | awk '{print $1}')

if [[ -z "$LBR_IP" ]]; then
    echo "Unable to determine stlb01 IP."
    exit 1
fi

echo "LBR IP: $LBR_IP"

#--------------------------------------------
# Configure Firewall
#--------------------------------------------
echo "[3/5] Configuring firewall..."

iptables -C INPUT -p tcp -s "$LBR_IP" --dport $PORT -j ACCEPT 2>/dev/null || \
iptables -I INPUT -p tcp -s "$LBR_IP" --dport $PORT -j ACCEPT

iptables -C INPUT -p tcp --dport $PORT -j DROP 2>/dev/null || \
iptables -A INPUT -p tcp --dport $PORT -j DROP

#--------------------------------------------
# Save Rules
#--------------------------------------------
echo "[4/5] Saving firewall rules..."

iptables-save > /etc/sysconfig/iptables

systemctl enable iptables
systemctl restart iptables

#--------------------------------------------
# Verify
#--------------------------------------------
echo "[5/5] Verification"

iptables -L INPUT -n --line-numbers

echo
echo "Firewall configuration completed successfully."
```
