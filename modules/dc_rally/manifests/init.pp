# Class: dc_rally
#
# Installs Rally and Tempest: https://wiki.openstack.org/wiki/Rally
#
# Parameters: auth_url, username, password, rallyhome
#
# Actions:
#
# Requires: vcsrepo
#
# Sample Usage:
#
class dc_rally (
  $auth_url   = 'https://openstack.datacentred.io:5000/v2.0',
  $username   = 'rally',
  $password   = undef,
  $rallyhome  = '/var/local/rally',
) {

  package { 'git':
    ensure => installed,
  }

  user { 'rally':
    ensure     => present,
    comment    => 'Account for rally - the OpenStack Tempest API test tool interface',
    managehome => true,
    home       => $rallyhome,
  }

  vcsrepo { "${rallyhome}/rally":
    ensure   => present,
    source   => 'https://github.com/stackforge/rally.git',
    provider => 'git',
    user     => $username,
    require  => [ Package['git'], User['rally'] ],
  } ->
  exec { 'install_rally':
    command => "${rallyhome}/rally/install_rally.sh",
    creates => '/usr/local/bin/rally',
  }

  file { "${rallyhome}/dcdev.json":
    ensure  => file,
    content => template('dc_rally/dcdev.json.erb'),
    require => Vcsrepo["${rallyhome}/rally"],
  }

  exec { 'create_deployment':
    command => "/usr/local/bin/rally deployment create --filename ${rallyhome}/dcdev.json --name=DataCentred",
    user    => $username,
    creates => "${rallyhome}/.rally/openrc",
  } ~>
  exec { 'deploy_tempest':
    command => '/usr/local/bin/rally-manage tempest install',
    user    => $username,
  }

  file { "${rallyhome}/boot-and-delete.json":
    ensure  => file,
    content => template('dc_rally/boot-and-delete.json.erb'),
    require => Vcsrepo["${rallyhome}/rally"],
  }

}
