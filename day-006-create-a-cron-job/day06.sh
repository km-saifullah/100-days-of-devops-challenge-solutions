#!/bin/bash

# Install cronie
yum install -y cronie

# Enable and start crond
systemctl enable crond
systemctl start crond

# Create root cron job
echo "*/5 * * * * echo hello > /tmp/cron_text" | crontab -

# Verify
crontab -l
systemctl is-active crond