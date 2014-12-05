# == Class: dc_postgresql::repmgr::master
#
class dc_postgresql::repmgr::master{

  # postgres configuration
  include ::dc_postgresql::repmgr::db
  include ::dc_postgresql::repmgr::local_connection
  include ::dc_postgresql::repmgr::slave_connection

  # repmgr configuration
  include ::dc_postgresql::repmgr::install
  include ::dc_postgresql::repmgr::config
  include ::dc_postgresql::repmgr::master::config

  Class['::dc_postgresql::repmgr::install'] ->
  Class['::dc_postgresql::repmgr::config'] ->
  Class['::dc_postgresql::repmgr::master::config']

}
