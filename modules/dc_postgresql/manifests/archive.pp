# == Class: dc_postgresql::archive
#
class dc_postgresql::archive {

  include ::dc_postgresql::params
  include ::dc_postgresql::install
  include ::dc_postgresql::archive::config
  include ::dc_postgresql::keys::backup
  include ::dc_postgresql::icinga

  Class['::dc_postgresql::params'] ->
  Class['::dc_postgresql::install'] ->
  Class['::dc_postgresql::archive::config'] ->
  Class['::dc_postgresql::keys::backup'] ->
  Class['::dc_postgresql::icinga']

}
