# Class: dc_profile::openstack::ceilometer_db
#
# OpenStack Ceilometer database configuration
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::ceilometer_db {

  contain dc_mariadb

  $ceilometer_db      = hiera(ceilometer_db)
  $ceilometer_db_user = hiera(ceilometer_db_user)
  $ceilometer_db_pass = hiera(ceilometer_db_pass)
  $ceilometer_server  = hiera(ceilometer_server_host)

  dc_mariadb::db { $ceilometer_db:
    user     => $ceilometer_db_user,
    password => $ceilometer_db_pass,
    host     => $ceilometer_server,
    require  => Class['Dc_mariadb'],
  }

}
