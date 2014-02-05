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

  realize Dc_repos::Virtual::Repo['local_mariadb_mirror']

  class { '::mysql::server':
    root_password => $maria_root_pw,
    package_name  => 'mariadb-server',
    require       => Dc_repos::Virtual::Repo['local_mariadb_mirror'],
  }

  class { 'dc_mariadb::icinga':
    require => Class['::mysql::server']
  }

  class {'dc_mariadb::exports':}

  class {'dc_mariadb::backupconf':
    require => [ Class['dc_mariadb::exports'], Class['::mysql::server']]
  }

}
