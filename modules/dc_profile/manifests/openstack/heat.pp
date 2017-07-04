# == Class: dc_profile::openstack::heat
#
class dc_profile::openstack::heat {

  $containers = hiera('containers')

  dc_docker::run { 'heat':
    * => $containers['heat']
  }

  logrotate::rule { 'heat':
    path          => '/var/log/heat/*.log',
    rotate        => 7,
    rotate_every  => 'day',
    compress      => true,
    delaycompress => true,
    missingok     => true,
    ifempty       => false,
  }

}
