# Class:
#
# Installs the icinga client on a host
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# class { icinga::client: }
#
class dc_icinga::client {

  include ::icinga::client

  # I am the current host, yes I am
  @@icinga::host { $::hostname:
    ensure          => present,
    alias           => $::fqdn,
    address         => $::ipaddress,
    check_command   => 'check_ping!100.0,20%!500.0,60%',
    use             => 'dc_host_generic',
    hostgroups      => template('dc_icinga/hostgroups.erb'),
    icon_image      => 'base/ubuntu.png',
    icon_image_alt  => 'Ubuntu 14.04 LTS (trusty)',
    notes           => 'Ubuntu 14.04 LTS servers',
    statusmap_image => 'base/ubuntu.gd2',
    vrml_image      => 'ubuntu.png',
  }

}
