# == Define: dc_postgresql::repmgr::master::cluster_connection
#
# A singlular hostname based allowed connection
#
define dc_postgresql::repmgr::master::cluster_connection {

  postgresql::server::pg_hba_rule { "repmgr accesss from ${title}":
    type        => 'host',
    database    => 'repmgr',
    user        => 'repmgr',
    address     => $title,
    auth_method => 'trust',
    order       => '099',
  }

  postgresql::server::pg_hba_rule { "replication accesss from ${title}":
    type        => 'host',
    database    => 'replication',
    user        => 'repmgr',
    address     => $title,
    auth_method => 'trust',
    order       => '099',
  }

}
