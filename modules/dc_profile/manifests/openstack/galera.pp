# Class: dc_profile::openstack::galera
#
# Configure Galera multi-master
#
# Parameters:
#
# Actions:
#
# Requires: galera, xinetd
#
# Sample Usage:
#
#
class dc_profile::openstack::galera {

  file { '/srv/mysql':
    ensure  => directory,
    recurse => true,
  }

  file { '/var/lib/mysql':
    ensure  => link,
    target  => '/srv/mysql',
    require => File['/srv/mysql'],
  }

  class { '::galera':
    require       => File['/var/lib/mysql'],
  }

  create_resources('mysql::db', hiera('databases'))
  Class['::galera'] -> Mysql::Db <||>

  # We only want to be our designated master to be actively written to,
  # unless it's failed of course. $::galera_master is set via Foreman
  if $::galera_master {
    $haproxy_options = 'check port 9200 inter 2000 rise 2 fall 5'
  }
  else {
    $haproxy_options = 'check port 9200 inter 2000 rise 2 fall 5 backup'
  }

  # Export our haproxy balancermember resource
  @@haproxy::balancermember { "${::fqdn}-galera":
    listening_service => 'galera',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress,
    ports             => '3306',
    options           => $haproxy_options,
  }

}
