# Class: dc_profile::openstack::keystone_db
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
class dc_profile::openstack::keystone_db {

  $keystone_db_pw = hiera(keystone_db_pw)

  dc_mariadb::db { 'keystone':
    user     => 'keystone',
    password => $keystone_db_pw,
    host     => '%',
    require  => Class['::galera'],
  }

}
