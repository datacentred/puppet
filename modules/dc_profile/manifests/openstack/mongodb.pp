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

  Mongodb_replset['ceilometer'] ->
  Mongodb::Db['ceilometer']
    
}
