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

  # And one for Nova
  $nova_db_user = hiera(nova_db_user)
  $nova_db_pass = hiera(nova_db_pass)
  $nova_db      = hiera(nova_db)

  mysql::db { $nova_db:
    user     => $nova_db_user,
    password => $nova_db_pass,
    require  => Class['::mysql::server'],
  }
}
