class dc_postgresql::repmgr::db {

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
  }

}
