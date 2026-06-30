#!/bin/bash

# Variables
SOURCE_DIR="/var/www/html/ecommerce"
ARCHIVE_DIR="/archives"
ARCHIVE_NAME="xfusioncorp_ecommerce.zip"
STORAGE_USER="storageuser"
STORAGE_SERVER="storageapp01"
STORAGE_DIR="/archives"

# Create archive directory if it doesn't exist
mkdir -p "$ARCHIVE_DIR"

# Create zip archive
zip -r "$ARCHIVE_DIR/$ARCHIVE_NAME" "$SOURCE_DIR"

# Copy archive to storage server
scp "$ARCHIVE_DIR/$ARCHIVE_NAME" "${STORAGE_USER}@${STORAGE_SERVER}:${STORAGE_DIR}/"

# Note: Replace natasha with the storage server user specified in your lab if it is different.