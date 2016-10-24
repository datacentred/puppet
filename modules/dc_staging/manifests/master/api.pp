# == Class: dc_staging::master::api
#
# The module the staging master api / control-plane
#
class dc_staging::master::api{

  class { 'supervisord':
    install_pip => true,
  }

  package{'undercloud-control-plane':}

  user { 'undercloud':
    system => true,
    ensure => present,
    groups => ['undercloud'],
  }

  group { 'undercloud':
    system => true,
    ensure => present,
  }

  supervisord::supervisorctl { 'undercloud-control-plane':
    command => 'restart',
    process => 'undercloud-control-plane'
  }

  Group['undercloud'] -> User['undercloud'] -> Package['undercloud-control-plane'] -> Supervisord::Supervisorctl['undercloud-control-plane'] 

}
