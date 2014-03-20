# Class: dc_profile::openstack::keystone_mariadb
#
# Provides a backend mysql database for keystone
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::keystone_mariadb {

  $keystone_db_pw        = hiera(keystone_db_pw)

  contain dc_mariadb

  dc_mariadb::db { 'keystone':
    user     => 'keystone',
    password => $keystone_db_pw,
  }

}
