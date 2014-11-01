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

  include ::mongodb::server
  include ::mongodb::replset

  mongodb::db { 'ceilometer':
    user     => 'ceilometer',
    password => hiera(ceilometer_db_password),
  }

  # Deploy our keyfile before we attempt to configure
  # the replicaset
  file { '/etc/mongodb.keyfile':
    content => hiera(ceilometer_mongodb_keyfile),
    mode    => 0600,
    owner   => 'mongodb',
    group   => 'mongodb',
    require => Package['mongodb-server'],
  } ->
  Mongodb_replset['ceilometer'] ->
  Mongodb::Db['ceilometer']
    
}
