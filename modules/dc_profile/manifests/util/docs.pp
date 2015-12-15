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

  postgresql::server::db { 'confluencedb':
    owner    => 'confluenceuser',
    user     => 'confluenceuser',
    password => $database_password,
  }
}
