class dc_postgresql::repmgr::slave::sync {

  include ::dc_postgresql::params

  runonce { 'stop_pg_presync':
    command => '/usr/sbin/service postgresql stop',
  } ->

  runonce { 'delete_all':
    command => "rm -rf ${dc_postgresql::params::pgdata}/*",
  } ->

  runonce { 'repmgr_initial_sync':
    command => "su postgres -c \"repmgr -D ${dc_postgresql::params::pgdata} -d repmgr -p 5432 -U repmgr -R postgres --verbose standby clone ${dc_postgresql::params::cluster_master_node}\"",
  } ->

  runonce { 'restart_postgres':
    command => '/usr/sbin/service postgresql start'
  } ->

  runonce { 'repmgr_standby_register':
    command => "repmgr -f ${dc_postgresql::params::pghome}/repmgr/repmgr.conf --verbose standby register"
  } ->

  service { 'repmgrd':
    ensure     => running,
    provider   => base,
    start      => "/usr/bin/repmgrd -f ${dc_postgresql::params::pghome}/repmgr/repmgr.conf --verbose --monitoring-history > ${dc_postgresql::params::pghome}/repmgr/repmgr.log 2>&1 &",
    stop       => 'killall repmgrd',
    hasrestart => false,
    hasstatus  => false,
  }

}
