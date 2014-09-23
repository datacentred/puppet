# Class: dc_profile::openstack::cinder_db
#
# OpenStack Cinder database definition
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::cinder_db {

  $cinder_db      = hiera(cinder_db)
  $cinder_db_user = hiera(cinder_db_user)
  $cinder_db_pass = hiera(cinder_db_pass)

  dc_mariadb::db { $cinder_db:
    user     => $cinder_db_user,
    password => $cinder_db_pass,
    host     => '%',
    require  => Class['::galera'],
  }

}
