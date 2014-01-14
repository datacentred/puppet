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

  # Each client gets all the plugins on earth
  package { 'nagios-plugins':
    ensure => present,
  }

  # I am the current host, yes I am
  @@nagios_host { $::hostname:
    ensure          => present,
    alias           => $::fqdn,
    address         => $::ipaddress,
    use             => 'dc_host_generic',
    hostgroups      => template('dc_icinga/hostgroups.erb'),
    icon_image      => 'base/ubuntu.png',
    icon_image_alt  => 'Ubuntu 12.04 LTS (precise)',
    notes           => 'Ubuntu 12.04 LTS servers',
    statusmap_image => 'base/ubuntu.gd2',
    vrml_image      => 'ubuntu.png',
  }

}
