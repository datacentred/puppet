# == Class: dc_postgresql::master
#
class dc_postgresql::master {

  include ::dc_postgresql::params
  include ::dc_postgresql::install
  include ::dc_postgresql::config
  include ::dc_postgresql::master::backup
  include ::dc_postgresql::master::repmgr
  include ::dc_postgresql::keys::cluster
  include ::dc_postgresql::keys::backup
  include ::dc_postgresql::icinga
  include ::dc_postgresql::databases


  Class['::dc_postgresql::params'] ->
  Class['::dc_postgresql::install'] ->
  Class['::dc_postgresql::config'] ->
  Class['::dc_postgresql::master::backup'] ->
  Class['::dc_postgresql::master::repmgr'] ->
  Class['::dc_postgresql::keys::cluster'] ->
  Class['::dc_postgresql::keys::backup'] ->
  Class['::dc_postgresql::icinga'] ->
  Class['::dc_postgresql::databases']

}
