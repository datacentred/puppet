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

  contain dc_mariadb

  $cinder_db      = hiera(cinder_db)
  $cinder_db_user = hiera(cinder_db_user)
  $cinder_db_pass = hiera(cinder_db_pass)
  $cinder_server  = hiera(cinder_server_host)

  dc_mariadb::db { $cinder_db:
    user     => $cinder_db_user,
    password => $cinder_db_pass,
    host     => $cinder_server,
    require  => Class['Dc_mariadb'],
  }

}
