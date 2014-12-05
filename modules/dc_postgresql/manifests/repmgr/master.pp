# == Class: dc_postgresql::repmgr::master
#
class dc_postgresql::repmgr::master{

  include ::dc_postgresql::params

  # run once we have been configured
  Class['::dc_postgresql::repmgr::config'] ->
  Class['::dc_postgresql::repmgr::master']

  # run once the database has been created
  Class['::dc_postgresql::repmgr::db'] ->
  Class['::dc_postgresql::repmgr::master']

  # run when we are allowed to connect locally
  Class['::dc_postgresql::repmgr::local_connection'] ->
  Class['::dc_postgresql::repmgr::master']

  runonce { 'register_master_repmgr':
    command => "repmgr -f ${dc_postgresql::params::pghome}/repmgr/repmgr.conf --verbose master register",
  }

}
