#!/bin/bash

# Variables
WAR_FILE="/tmp/ROOT.war"
WEBAPPS="/usr/share/tomcat/webapps"
SERVER_XML="/etc/tomcat/server.xml"

# Install Tomcat
yum install -y tomcat tomcat-webapps tomcat-admin-webapps

# Change Tomcat port to 5001
sed -i 's/port="8080"/port="5001"/' "$SERVER_XML"

# Remove default ROOT application
rm -rf "$WEBAPPS/ROOT"
rm -f "$WEBAPPS/ROOT.war"

# Deploy application
cp "$WAR_FILE" "$WEBAPPS/ROOT.war"

# Enable and restart Tomcat
systemctl enable tomcat
systemctl restart tomcat

# Verify
systemctl status tomcat --no-pager
curl http://localhost:5001