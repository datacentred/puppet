class dc_postgresql::repmgr::local_connection {

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
