# == Class: dc_dhcp
#
# Common setup for primary and secondary dhcp servers.  Installs the
# synchronisation agent user and configures passwordless ssh and sudo
# rights to restart the dhcp daemon
#
class dc_dhcp (
  $zonemaster,
  $default_lease_time,
  $max_lease_time,
  $dhcp_icinga_mac,
  $dhcp_icinga_ip,
) {

  assert_private()

  include ::dc_dhcp::params

  user { 'dhcp_sync_agent':
    ensure     => present,
    system     => true,
    managehome => true,
  } ->

  passwordless_ssh { 'dhcp_sync_agent':
    ssh_private_key   => $dc_dhcp::params::ssh_private_key,
    ssh_public_key    => $dc_dhcp::params::ssh_public_key,
    sudo              => true,
    sudo_users        => 'ALL',
    sudo_applications => 'ALL',
    #sudo_users        => 'root',
    #sudo_applications => '/etc/init.d/isc-dhcp-server',
  }

  file { '/usr/local/lib/python2.7/dist-packages/dc_dhcp_parser.py':
    ensure => file,
    source => 'puppet:///modules/dc_dhcp/dc_dhcp_parser.py',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  package { 'python-pyparsing':
    ensure => installed,
  }

  $pool_dfl = {
    'zonemaster' => $zonemaster,
    'parameters' => [ "default-lease-time ${default_lease_time}", "max-lease-time ${max_lease_time}" ]
  }

  $merged_pools = hiera_hash('dc_dhcp::pools')

  create_resources('dhcp::pool', $merged_pools, $pool_dfl)

}
