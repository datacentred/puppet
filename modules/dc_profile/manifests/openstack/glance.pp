# == Class: dc_profile::openstack::glance
#
# The OpenStack image service in a Docker container
#
class dc_profile::openstack::glance {

  include ::dc_icinga::hostgroup_glance

  $containers = hiera('containers')

  dc_docker::run { 'glance':
    * => $containers['glance']
  }

  logrotate::rule { 'glance':
    path          => '/var/log/glance/*.log',
    rotate        => 7,
    rotate_every  => 'day',
    compress      => true,
    delaycompress => true,
    missingok     => true,
    ifempty       => false,
  }

}
