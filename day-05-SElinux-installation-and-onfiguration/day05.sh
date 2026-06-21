#!/bin/bash

# Install SELinux packages
yum install -y selinux-policy selinux-policy-targeted policycoreutils

# Permanently disable SELinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

# Verify configuration
grep ^SELINUX= /etc/selinux/config