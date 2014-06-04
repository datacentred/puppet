# Class: dc_mariadb
#
# Top level class to install the db
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_mariadb (
  $maria_root_pw      = undef,
){

  class { '::mysql::server':
    root_password    => $maria_root_pw,
    package_name     => 'mariadb-server',
    override_options => {
      'mysqld' => {
        'bind_address' => '0.0.0.0',
      }
    },
  }
  contain 'mysql::server'

  # Fix log file ownership bug which causes logrotate to error
  file { '/var/log/mysql/error.log':
    ensure  => file,
    require => Class['::mysql::server'],
    owner   => mysql,
    group   => mysql,
  }

  class { 'dc_mariadb::icinga':
    require => Class['::mysql::server']
  }

  contain dc_mariadb::exports

  class {'dc_mariadb::backupconf':
    require => [
      Class['::mysql::server'],
      Class['dc_mariadb::exports'],
    ],
  }
  
  unless $::is_vagrant {
    include dc_mariadb::collectd
  }
}
