# Class: dc_profile::openstack::glance_registry_db
#
# Openstack image registry database definitions
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::glance_registry_db {

  $glance_reg_db      = hiera(glance_reg_db)
  $glance_reg_db_user = hiera(glance_reg_db_user)
  $glance_reg_db_pass = hiera(glance_reg_db_pass)

  dc_mariadb::db { $glance_reg_db:
    user     => $glance_reg_db_user,
    password => $glance_reg_db_pass,
    host     => '%',
    require  => Class['::galera'],
  }

}
