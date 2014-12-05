# == Class: dc_postgresql::repmgr::slave
#
class dc_postgresql::repmgr::slave {

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

}
