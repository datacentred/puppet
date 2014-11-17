# Class: dc_profile::openstack::heat_db
#
# OpenStack Heat Orchestration service database definition
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::heat_db {

  $heat_db      = hiera(heat_db)
  $heat_db_user = hiera(heat_db_user)
  $heat_db_pass = hiera(heat_db_pass)

  dc_mariadb::db { $heat_db:
    user     => $heat_db_user,
    password => $heat_db_pass,
    host     => '%',
    require  => Class['::galera'],
  }

}
