# Class: dc_profile::openstack::mongodb
#
# MongoDB installation supporting OpenStack Ceilometer
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::mongodb {

  include ::mongodb::globals
  include ::mongodb::server
  include ::mongodb::client
  include ::mongodb::replset

  Class['::mongodb::server'] ->
  Class['::mongodb::client']

  # Deploy our keyfile before we attempt to configure
  # the replicaset
  file { '/etc/mongodb.keyfile':
    content => hiera(ceilometer_mongodb_keyfile),
    mode    => '0600',
    owner   => 'mongodb',
    group   => 'mongodb',
    require => Package['mongodb-org-server'],
  } ->
  Mongodb_replset['ceilometer']
}


