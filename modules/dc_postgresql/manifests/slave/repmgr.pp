# == Class: dc_postgresql::slave::repmgr
#
class dc_postgresql::slave::repmgr {

  include ::dc_postgresql::params

  $node_id = array_index($dc_postgresql::params::cluster_standby_nodes, $::hostname) + 1

  @@postgresql::server::pg_hba_rule { "repmgr from ${::hostname}":
    description => "repmgr access from ${::hostname}",
    type        => 'host',
    database    => 'repmgr',
    user        => 'repmgr',
    address     => "${::ipaddress}/32",
    auth_method => 'trust',
    tag         => 'slave',
    order       => '099',
  }

  @@postgresql::server::pg_hba_rule { "replication from ${::hostname}":
    description => "replication access from ${::hostname}",
    type        => 'host',
    database    => 'replication',
    user        => 'repmgr',
    address     => "${::ipaddress}/32",
    auth_method => 'trust',
    tag         => 'slave',
    order       => '099',
  }

  file { "${dc_postgresql::params::pghome}/repmgr":
    ensure  => directory,
  }

  file { "${dc_postgresql::params::pghome}/repmgr/repmgr.conf":
    ensure  => file,
    content => template('dc_postgresql/repmgr.conf.erb'),
  }

  postgresql::server::pg_hba_rule { 'repmgr local ipv4':
    description => 'repmgr access from local ip',
    type        => 'host',
    database    => 'repmgr',
    user        => 'repmgr',
    address     => "${::ipaddress}/32",
    auth_method => 'trust',
    tag         => 'slave',
    order       => '099',
  }

}
