#!/bin/bash

useradd -e 2024-02-17 rose

if id rose >/dev/null 2>&1; then
echo "User rose created successfully."
echo "Expiry date: $(chage -l rose | grep "Account expires" | cut -d: -f2 | xargs)"
else
echo "Failed to create user rose."
exit 1
fi