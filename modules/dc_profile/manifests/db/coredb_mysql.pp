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
class dc_profile::db::coredb_mysql (
  $databases,
  $mysql_pw,
){

  class { '::dc_mariadb':
    maria_root_pw => $mysql_pw,
  }
  contain 'dc_mariadb'

  $db_defaults = {
    grant   => ['ALL'],
    require => Class['::dc_mariadb'],
  }

  create_resources(dc_mariadb::db, $databases, $db_defaults)

}
