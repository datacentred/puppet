#!/bin/bash

if [[ "`pidof -x $(basename $0) -o %PPID`" ]]; then
    echo "This script is already running with PID `pidof -x $(basename $0) -o %PPID`"
    exit 1
fi

if ! diff /tmp/dhcpd.hosts /etc/dhcp/dhcpd.hosts; then
  TIMESTAMP=`date | tr '\n' ']'`
  echo "[${TIMESTAMP} Synchronizing /etc/dhcp/dhcpd.hosts" > /var/log/dhcp_sync_hosts.log
  if ! cp /tmp/dhcpd.hosts /etc/dhcp/dhcpd.hosts
  then
    echo "Could not copy file"
    exit 1
  fi
  if ! service isc-dhcp-server stop
  then
    echo "Could not stop server"
    exit 1
  fi
  if ! rm /var/lib/dhcp/dhcpd.leases*
  then
    echo "Could not clear existing leases"
    exit 1
  else
    touch /var/lib/dhcp/dhcpd.leases
  fi
  if ! service isc-dhcp-server start
  then
    echo "Could not start server"
    exit 1
  fi
fi

