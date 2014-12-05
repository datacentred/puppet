# == Class: dc_postgresql::repmgr::slave
#
class dc_postgresql::repmgr::slave {

  # postgres configuration
  include ::dc_postgresql::repmgr::local_connection

  # repmgr configuration
  include ::dc_postgresql::repmgr::install
  include ::dc_postgresql::repmgr::config
  include ::dc_postgresql::repmgr::slave::hba
  include ::dc_postgresql::repmgr::slave::sync
  include ::dc_postgresql::repmgr::slave::config

  Class['::dc_postgresql::repmgr::install'] ->
  Class['::dc_postgresql::repmgr::config'] ->
  Class['::dc_postgresql::repmgr::slave::config'] ->
  Class['::dc_postgresql::repmgr::slave::sync']

}
