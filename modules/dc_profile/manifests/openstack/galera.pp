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

  include ::galera
  include ::mysql::server::monitor

  file { '/srv/mysql':
    ensure  => directory,
    recurse => true,
  } ->

  file { '/var/lib/mysql':
    ensure => link,
    target => '/srv/mysql',
  } ->

  Class['::galera'] ->

  Mysql::Db <||>

  create_resources('mysql::db', hiera('databases'))

}
