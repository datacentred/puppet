class dc_profile::coredb_mysql {

  $mysql_pw = hiera(db0_mysql_pw)
  $graphite_db_pw = hiera(graphite_db_pw)
  $graphite_server = hiera(graphite_server)

  class { '::mysql::server':
    root_password    => $mysqlroot_pw,
    override_options => { 'mysqld' => {
      'bind_address' => $::ipaddress
      }
    }
  }

  mysql::db { 'graphite':
    user     => 'graphite',
    host     => $graphite_server,
    password => $graphite_db_pw,
    grant    => ['ALL'],
    require  => Class['::mysql::server']
  }

}
