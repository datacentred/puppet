# Class: dc_profile::openstack::glance_db
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
class dc_profile::openstack::glance_db {

  $glance_db      = hiera(glance_db)
  $glance_db_user = hiera(glance_db_user)
  $glance_db_pass = hiera(glance_db_pass)

  dc_mariadb::db { $glance_db:
    user     => $glance_db_user,
    password => $glance_db_pass,
    host     => '%',
    require  => Class['::galera'],
  }

}
