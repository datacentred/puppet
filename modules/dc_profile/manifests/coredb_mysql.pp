# Installation of MySQL as well as any associated databases
class dc_profile::coredb_mysql {

  $mysqlroot_pw = hiera(db0_mysql_pw)
  $graphite_db_pw = hiera(graphite_db_pw)
  $graphite_server = hiera(graphite_server)

  class { '::mysql::server':
    root_password    => $mysqlroot_pw,
    override_options => { 'mysqld' => {
      'bind_address' => '0.0.0.0',
      },
    },
  }

  contain 'mysql::server'

# MySQL database backend for Graphite
  mysql::db { 'graphite':
    user     => 'graphite',
    host     => $graphite_server,
    password => $graphite_db_pw,
    grant    => ['ALL'],
    require  => Class['::mysql::server'],
  }


  # Glance API and registry
  $glance_api_db   = hiera(glance_api_db)
  $glance_api_user = hiera(glance_api_user)
  $glance_api_pass = hiera(glance_api_pass)

  mysql::db { $glance_api_db:
    user     => $glance_api_user,
    password => $glance_api_pass,
    require  => Class['::mysql::server'],
  }

  $glance_reg_db   = hiera(glance_reg_db)
  $glance_reg_user = hiera(glance_reg_user)
  $glance_reg_pass = hiera(glance_reg_pass)

  mysql::db { $glance_reg_db:
    user     => $glance_reg_user,
    password => $glance_reg_pass,
    require  => Class['::mysql::server'],
  }

}
