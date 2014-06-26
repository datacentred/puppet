# Class: dc_profile::wordpress::database
#
# Customer-facing website database definition
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::wordpress::database {

  contain dc_mariadb

  $wordpress_db      = hiera(wordpress_db)
  $wordpress_db_user = hiera(wordpress_db_user)
  $wordpress_db_pass = hiera(wordpress_db_pass)
  $wordpress_host    = hiera(wordpress_host)

  dc_mariadb::db { $wordpress_db:
    user     => $wordpress_db_user,
    password => $wordpress_db_pass,
    host     => $wordpress_host,
    require  => Class['Dc_mariadb'],
  }
}
