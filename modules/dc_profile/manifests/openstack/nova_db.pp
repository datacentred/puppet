# Class: dc_profile::openstack::nova_db
#
# Openstack compute database definitions
#
# Parameters:
#
# Actions:
#
# Requires:
#   
# Sample Usage:
#
class dc_profile::openstack::nova_db {

  $nova_db_user        = hiera(nova_db_user)
  $nova_db_pass        = hiera(nova_db_pass)
  $nova_db             = hiera(nova_db)
  $nova_host           = hiera(nova_host)

  dc_mariadb::db { $nova_db:
    user     => $nova_db_user,
    password => $nova_db_pass,
    host     => $nova_host,
  }

}
