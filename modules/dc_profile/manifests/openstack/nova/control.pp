# Class: dc_profile::openstack::nova::control
#
# OpenStack Nova control components profile class
#
class dc_profile::openstack::nova::control {

  include ::dc_icinga::hostgroup_nova_server

  $containers = hiera('containers')

  dc_docker::run { 'nova':
    * => $containers['nova']
  }

  logrotate::rule { 'nova':
    path          => '/var/log/nova/*.log',
    rotate        => 7,
    rotate_every  => 'day',
    compress      => true,
    delaycompress => true,
    missingok     => true,
    ifempty       => false,
  }

}
