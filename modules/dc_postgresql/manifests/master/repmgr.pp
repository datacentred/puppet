# == Class: dc_postgresql::master::repmgr
#
class dc_postgresql::master::repmgr {

  include ::dc_postgresql::params

  $node_id = '0'

  postgresql::server::role { 'repmgr':
    username  => 'repmgr',
    login     => true,
    superuser => true,
  } ->

  postgresql::server::database { 'repmgr':
    dbname  => 'repmgr',
    owner   => 'repmgr',
  } ->

  postgresql::server::database_grant { 'repmgr':
    privilege => 'ALL',
    db        => 'repmgr',
    role      => 'repmgr',
  } ->

  postgresql::server::pg_hba_rule { 'repmgr local ipv4':
    description => 'repmgr access from local ip',
    type        => 'host',
    database    => 'repmgr',
    user        => 'repmgr',
    address     => "${::ipaddress}/32",
    auth_method => 'trust',
    tag         => 'slave',
    order       => '099',
  } ->

  file { "${dc_postgresql::params::pghome}/repmgr":
    ensure  => directory,
  } ->

  file { "${dc_postgresql::params::pghome}/repmgr/repmgr.conf":
    ensure  => file,
    content => template('dc_postgresql/repmgr.conf.erb'),
    require => File["${dc_postgresql::params::pgdata}/../../repmgr"],
  } ->

  runonce { 'register_master_repmgr':
    command => "repmgr -f ${dc_postgresql::params::pghome}/repmgr/repmgr.conf --verbose master register",
  }

  # connection requirements are exported from the members of the cluster
  # realize them here

  Postgresql::Server::Pg_hba_rule <<| tag == 'slave' |>>

}
