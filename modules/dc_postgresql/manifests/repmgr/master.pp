# == Class: dc_postgresql::repmgr::master
#
class dc_postgresql::repmgr::master {

  # floating postgres configuration
  include ::dc_postgresql::repmgr::master::db
  include ::dc_postgresql::repmgr::cluster_connections

  # repmgr configuration
  include ::dc_postgresql::repmgr::install
  include ::dc_postgresql::repmgr::config

  Class['::dc_postgresql::repmgr::install'] ->
  Class['::dc_postgresql::repmgr::config']

}
