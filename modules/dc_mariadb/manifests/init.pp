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

  realize Dc_repos::Repo['local_mariadb_mirror']

  class { '::mysql::server':
    root_password     => $maria_root_pw,
    package_name      => 'mariadb-server',
    require           => Dc_repos::Repo['local_mariadb_mirror'],
    override_options => { 'mysqld' => { 'bind_address' => '0.0.0.0' } }
  }
  contain 'mysql::server'

  class { 'dc_mariadb::icinga':
    require => Class['::mysql::server']
  }

  class {'dc_mariadb::exports':}

  class {'dc_mariadb::backupconf':
    require => Class['dc_mariadb::exports']
  }

}
