# == Class: dc_postgresql::slave
#
class dc_postgresql::slave {

  include ::dc_postgresql::params
  include ::dc_postgresql::install
  include ::dc_postgresql::config
  include ::dc_postgresql::slave::repmgr
  include ::dc_postgresql::slave::standby_sync
  include ::dc_postgresql::keys::cluster
  include ::dc_postgresql::keys::slave
  include ::dc_postgresql::icinga

  Class['::dc_postgresql::params'] ->
  Class['::dc_postgresql::install'] ->
  Class['::dc_postgresql::config'] ->
  Class['::dc_postgresql::slave::repmgr'] ->
  Class['::dc_postgresql::slave::standby_sync'] ->
  Class['::dc_postgresql::keys::cluster'] ->
  Class['::dc_postgresql::keys::slave'] ->
  Class['::dc_postgresql::icinga']

}
