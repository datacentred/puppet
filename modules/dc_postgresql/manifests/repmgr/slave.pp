# == Class: dc_postgresql::repmgr::slave
#
class dc_postgresql::repmgr::slave {

  # floating postgres configuration
  include ::dc_postgresql::repmgr::slave::local_connection

  # repmgr configuration
  include ::dc_postgresql::repmgr::install
  include ::dc_postgresql::repmgr::config
  include ::dc_postgresql::repmgr::slave::sync

  Class['::dc_postgresql::repmgr::install'] ->
  Class['::dc_postgresql::repmgr::config'] ->
  Class['::dc_postgresql::repmgr::slave::sync']

}
