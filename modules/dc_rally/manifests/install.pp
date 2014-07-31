class dc_rally::install (
  $username   = $dc_rally::params::username,
  $rallyhome  = $dc_rally::params::rallyhome,
) inherits dc_rally::params {

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

}
