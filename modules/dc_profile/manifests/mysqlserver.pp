class dc_profile::mysqlserver {

  $mysqlrootpw = hiera(mysql_root_pw)

  class { 'mysql::server':
    config_hash => { 'root_password' => $mysqlrootpw }
  }

}
