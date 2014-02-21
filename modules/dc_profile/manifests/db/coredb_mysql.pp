# Class: dc_profile::db::coredb_mysql
#
# Installation of MySQL as well as any associated databases
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::db::coredb_mysql {

  $mysqlroot_pw    = hiera(db0_mysql_pw)
  $graphite_db_pw  = hiera(graphite_db_pw)
  $graphite_server = hiera(graphite_server)

  class { '::dc_mariadb':
    maria_root_pw => $mysqlroot_pw,
  }
  contain 'dc_mariadb'

  # MySQL database backend for Graphite
  dc_mariadb::db { 'graphite':
    user     => 'graphite',
    host     => $graphite_server,
    password => $graphite_db_pw,
    grant    => ['ALL'],
    require  => Class['::dc_mariadb'],
  }

}
