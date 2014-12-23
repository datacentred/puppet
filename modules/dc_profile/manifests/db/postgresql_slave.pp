# == Class: dc_profile::db::postgresql_slave
#
class dc_profile::db::postgresql_slave {

  include ::dc_postgresql
  include ::dc_postgresql::icinga
  include ::dc_postgresql::repmgr::slave

  Class['::dc_postgresql'] ->
  Class['::dc_postgresql::repmgr::slave']


}
