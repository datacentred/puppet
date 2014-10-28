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

  $ceilometer_db_password = hiera(ceilometer_db_password)

  mongodb_database  { 'ceilometer':
    user     => 'ceilometer',
    password => $ceilometer_db_password,
  }
    
}
