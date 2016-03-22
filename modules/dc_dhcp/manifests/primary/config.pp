# == Class: dc_dhcp::primary::config
#
# Configure the dhcp synchronisation agent
#
class dc_dhcp::primary::config {

  assert_private()

  include ::dc_dhcp::params

  $dhcp_icinga_mac = $dc_dhcp::params::dhcp_icinga_mac
  $dhcp_icinga_ip = $dc_dhcp::params::dhcp_icinga_ip

  file { '/etc/default/dhcp_sync_agent':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
    content => "SECONDARY_HOST=${dc_dhcp::params::secondary_dhcp_host}",
  }

  file { '/etc/dhcp/dhcpd.misc':
    ensure  => file,
    content => template('dc_dhcp/dhcpd.misc.erb'),
    owner   => 'root',
    group   => 'root',
  }

  # Work around bug in dhcp server which doesn't rotate leases file
  cron { 'dhcp_restart':
    command => '/sbin/restart isc-dhcp-server 1>/dev/null',
    user    => 'root',
    hour    => 6,
    minute  => 0,
  }

}
