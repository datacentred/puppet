# == Class: dc_profile::openstack::keystone
#
# A class to deploy OpenStack Keystone in a container
#
class dc_profile::openstack::keystone {

  include ::dc_icinga::hostgroup_keystone

  $containers = hiera('containers')

  dc_docker::run { 'keystone':
    * => $containers['keystone']
  }

  logrotate::rule { 'keystone':
    path          => '/var/log/keystone/*.log',
    rotate        => 7,
    rotate_every  => 'day',
    compress      => true,
    delaycompress => true,
    missingok     => true,
    ifempty       => false,
  }

}
