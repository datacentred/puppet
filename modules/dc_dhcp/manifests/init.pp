# == Class: dc_dhcp
#
# Common setup for primary and secondary dhcp servers.  Installs the
# synchronisation agent user and configures passwordless ssh and sudo
# rights to restart the dhcp daemon
#
class dc_dhcp {

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
  }

  package { 'python-pyparsing':
    ensure => installed,
  }

}
