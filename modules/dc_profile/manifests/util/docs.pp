# Class: dc_profile::util::docs
#
# Manage in-house Confluence installation  
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
class dc_profile::util::docs {
  include ::java
  include ::confluence
  include ::nginx
  include ::postgresql::server

  $postgres_server = hiera('confluence_postgresql_password')
  $database_password = hiera('confluence_database_password')

  nginx::resource::upstream { 'confluence':
    ensure  => present,
    members => [ 'localhost:8080' ],
  }

  nginx::resource::vhost { $::fqdn:
    proxy       => 'http://confluence',
    server_name => [ $::fqdn, 'ddms.datacentred.co.uk', 'http://confluence' ],
  }

  postgresql::server::role { 'confluenceadmin':
    login    => true,
    createdb => true,
  }
  postgresql::server::db { 'confluence':
    owner    => 'confluenceuser',
    user     => 'confluenceuser',
    password => $database_password,
  }
}
class { 'postgresql::server':
    user             => 'confluenceuser',
    postgresql_pass  => $postgres_server,
    listen_addresses => '*',
}
