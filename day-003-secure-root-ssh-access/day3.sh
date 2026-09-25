#!/bin/bash

useradd -s /sbin/nologin mariyam

if id mariyam >/dev/null 2>&1; then
    echo "User mariyam created successfully."
    echo "Shell: $(getent passwd mariyam | cut -d: -f7)"
else
    echo "Failed to create user mariyam."
    exit 1
fi