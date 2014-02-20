# Class: dc_profile::openstack::keystone_postgres
#
# Provides a postgres database packend for keystone
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::keystone_postgres {

  $keystone_db_pw = hiera(keystone_db_pw)

  class { 'dc_postgresql': }

  dc_postgresql::db { 'keystone':
    user           => 'keystone',
    password       => $keystone_db_pw,
  }

}
