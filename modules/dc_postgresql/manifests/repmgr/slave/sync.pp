# == Class: dc_postgresql::repmgr::slave::sync
#
# Synchronise the slave to the master
#
class dc_postgresql::repmgr::slave::sync {

  include ::dc_postgresql::params

  $_pg_home = $::dc_postgresql::params::pghome

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
    command => "repmgr -f ${_pg_home}/repmgr/repmgr.conf --verbose standby register"
  } ->

  file { '/etc/default/repmgrd':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('dc_postgresql/repmgrd.default.erb'),
    notify  => Service['repmgrd'],
  }

  service { 'repmgrd':
    ensure  => running,
    require => File['/etc/default/repmgrd'],
  }

}
