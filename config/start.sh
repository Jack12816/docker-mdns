#!/bin/bash

# Fallback to *nginx* if nothing is specified
if [ -z "${MDNS_HOSTNAME}" ]; then
    export MDNS_HOSTNAME='nginx'
fi

# Setup the hostname on the avahi config
# (We use the HOSTNAME environment variable for this)
sed "s/\(host-name=\).*/\1${MDNS_HOSTNAME}/g" \
    -i /etc/avahi/avahi-daemon.conf

# Required services for mDNS to work on debian
/etc/init.d/dbus start
/etc/init.d/avahi-daemon start

# Some logging
echo
echo 'nginx is up and running. You should be able to access'
echo "it under: http://${MDNS_HOSTNAME}.local"

# Start nginx like normal
nginx -g 'daemon off;'
