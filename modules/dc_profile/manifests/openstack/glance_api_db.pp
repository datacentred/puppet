# Class: dc_profile::openstack::glance_api_db
#
# Openstack image API database definitions
#
# Parameters:
#
# Actions:
#
# Requires:
#   
# Sample Usage:
#
class dc_profile::openstack::glance_api_db {

  contain dc_mariadb

  $glance_api_db   = hiera(glance_api_db)
  $glance_api_user = hiera(glance_api_user)
  $glance_api_pass = hiera(glance_api_pass)

  dc_mariadb::db { $glance_api_db:
    user     => $glance_api_user,
    password => $glance_api_pass,
    require  => Class['Dc_mariadb'],
  }

}
