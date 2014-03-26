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

  include dc_mariadb

  $glance_reg_db   = hiera(glance_reg_db)
  $glance_reg_user = hiera(glance_reg_user)
  $glance_reg_pass = hiera(glance_reg_pass)

  dc_mariadb::db { $glance_reg_db:
    user     => $glance_reg_user,
    password => $glance_reg_pass,
    require  => Class['Dc_mariadb'],
  }

}
