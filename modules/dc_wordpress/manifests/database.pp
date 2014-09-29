# Class: dc_wordpress::database
#
# Setup mariadb server and a wordpress database
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_wordpress::database (
  $db_user = undef,
  $db_pass = undef,
  $db_host = undef,
  $db_name = undef,
) {

  contain dc_mariadb

  dc_mariadb::db { $db_name:
    user     => $db_user,
    password => $db_pass,
    host     => $db_host,
    require  => Class['Dc_mariadb'],
  }
}
