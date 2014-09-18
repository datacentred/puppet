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

  $glance_api_db      = hiera(glance_api_db)
  $glance_api_db_user = hiera(glance_api_db_user)
  $glance_api_db_pass = hiera(glance_api_db_pass)

  dc_mariadb::db { $glance_api_db:
    user     => $glance_api_db_user,
    password => $glance_api_db_pass,
  }

}
