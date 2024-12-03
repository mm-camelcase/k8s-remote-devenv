#!/bin/bash
set -e

source kubedock_setup

#chcon -Rt svirt_sandbox_file_t /home/user
#set -e

# Adjust ownership and permissions dynamically
#if [ "$(id -u)" != "10001" ]; then
#    echo "Adjusting permissions for OpenShift dynamic UID..."
#    chown -R $(id -u):0 /home/user
#    chmod -R g+rwX /home/user
#fi

# Start the SSH daemon
#/usr/sbin/sshd -f /home/user/custom-ssh/sshd_config -e


exec "$@"
