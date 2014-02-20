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

  $keystone_mariaroot_pw = hiera(keystone_mariaroot_pw)
  $keystone_db_pw        = hiera(keystone_db_pw)

  class { 'dc_mariadb':
    maria_root_pw => $keystone_mariaroot_pw,
  }
  contain 'dc_mariadb'

  dc_mariadb::db { 'keystone':
    user     => 'keystone',
    password => $keystone_db_pw,
  }

}
