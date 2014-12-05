# == Class: dc_postgresql
#
class dc_postgresql {

  include ::dc_postgresql::install
  include ::dc_postgresql::config

  Class['::dc_postgresql::install'] ->
  Class['::dc_postgresql::config']
}
