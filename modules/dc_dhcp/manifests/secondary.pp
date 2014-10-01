# == Class: dc_dhcp::secondary
#
# Installs the dhcp synchronisation agent on the dhcp master node
#
class dc_dhcp::secondary {

  include ::dc_dhcp

  file { '/etc/dhcp/dhcpd.hosts':
    ensure => file,
    owner  => 'dhcp_sync_agent',
    group  => 'dhcp_sync_agent',
    mode   => '0664',
  } ->

  file { '/var/log/dhcp_sync_hosts.log':
    ensure => file,
    owner  => 'dhcp_sync_agent',
    group  => 'dhcp_sync_agent',
    mode   => '0664',
  } ->

  file { '/usr/local/bin/dhcp_sync_hosts.sh':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/dc_dhcp/dhcp_sync_hosts.sh',
  }

}
