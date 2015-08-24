# == Define: dc_postgresql::repmgr::slave::cluster_connection
#
# A singular hostname based allowed connection
#
define dc_postgresql::repmgr::slave::cluster_connection {

  postgresql::server::pg_hba_rule { "repmgr accesss from ${title}":
    type        => 'host',
    database    => 'repmgr',
    user        => 'repmgr',
    address     => $title,
    auth_method => 'trust',
    order       => '099',
  }

}
