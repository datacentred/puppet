#!/bin/bash

if ! diff /tmp/dhcpd.hosts /etc/dhcp/dhcpd.hosts; then
  TIMESTAMP=`date | tr '\n' ']'`
  echo "[${TIMESTAMP} Synchronizing /etc/dhcp/dhcpd.hosts" > /var/log/dhcp_sync_hosts.log
  if ! cp /tmp/dhcpd.hosts /etc/dhcp/dhcpd.hosts
  then
       echo "Could not copy file"
       exit 1
  fi
  if ! sudo /etc/init.d/isc-dhcp-server restart
  then
       echo "Could not restart server"
       exit 1
  fi
fi

