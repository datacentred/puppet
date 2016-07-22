# == Class: dc_postgresql::repmgr::slave::configure
#
# Synchronise the slave to the master
#
class dc_postgresql::repmgr::slave::configure {

  $_home = $::dc_postgres::repmgr::home
  $_conf = "${::dc_postgresql::repmgr::home}/repmgr.conf"
  $_data = "${::dc_postgresql::repmgr::home}/${::dc_postgresql::repmgr::version}/main"
  $_master = $::dc_postgresql::repmgr::cluster_master

  runonce { 'stop_pg_presync':
    command => '/usr/sbin/service postgresql stop',
  } ->

  runonce { 'delete_all':
    command => "rm -rf ${_data}/*",
  } ->

  runonce { 'repmgr_initial_sync':
    command => "repmgr -f ${_conf} -D ${_data} -d repmgr -p 5432 -U repmgr -R postgres --verbose standby clone ${_master}",
    user    => 'postgres',
  } ->

  runonce { 'restart_postgres':
    command => '/usr/sbin/service postgresql start'
  } ->

  runonce { 'repmgr_standby_register':
    command => "repmgr -f ${_conf} --verbose standby register",
    user    => 'postgres',
  } ->

  file { '/etc/default/repmgrd':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('dc_postgresql/repmgrd.default.erb'),
  } ~>

  service { 'repmgrd':
    ensure => running,
    enable => true,
  }

}
