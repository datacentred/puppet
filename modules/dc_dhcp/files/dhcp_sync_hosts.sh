#!/bin/bash

if ! diff /tmp/dhcp.hosts /etc/dhcp/dhcpd.hosts; then
  TIMESTAMP=`date | tr '\n' ']'`
  echo "[${TIMESTAMP} Synchronizing /etc/dhcp/dhcpd.hosts" > /var/log/dhcp_sync_hosts.log
  cp /tmp/dhcp.hosts /etc/dhcp/dhcpd.hosts
  sudo /etc/init.d/isc-dhcp-server restart
fi

