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
    mode   => '664',
  }

}
