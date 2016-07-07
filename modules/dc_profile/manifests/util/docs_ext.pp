# Class: dc_profile::util::docs_ext
#
# Manage Confluence installation for external docs host
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
class dc_profile::util::docs_ext {

  include ::java
  include ::confluence
  include ::nginx
  include ::postgresql::server
  include ::dc_backup

  $database_password = hiera('confluence_database_password')

  nginx::resource::upstream { 'confluence':
    ensure  => present,
    members => [ 'localhost:8080' ],
  }

  nginx::resource::vhost { $::fqdn:
    proxy       => 'http://confluence',
    server_name => [ $::fqdn, 'docs.datacentred.io', 'http://confluence' ],
  }

  postgresql::server::role { 'confluenceuser':
    login    => true,
    createdb => true,
    password_hash => postgresql_password('confluenceuser', "$database_password"),
  }

  postgresql::server::db { 'confluencedb':
    owner    => 'confluenceuser',
    user     => 'confluenceuser',
    password => postgresql_password('confluenceuser', '$database_password'),
  }

  dc_backup::dc_duplicity_job { "${::fqdn}_confluencexml" :
    cloud          => 's3',
    backup_content => 'homedir',
    source_dir     => '/home/confluence/backups/',
  }

}
