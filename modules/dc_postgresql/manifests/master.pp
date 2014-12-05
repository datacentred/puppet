# == Class: dc_postgresql::master
#
class dc_postgresql::master {

  include ::dc_postgresql::install
  include ::dc_postgresql::config
  include ::dc_postgresql::backup
  include ::dc_postgresql::repmgr::db
  include ::dc_postgresql::repmgr::config
  include ::dc_postgresql::repmgr::local_connection
  include ::dc_postgresql::repmgr::slave_connection
  include ::dc_postgresql::repmgr::master
  include ::dc_postgresql::keys::cluster
  include ::dc_postgresql::keys::backup
  include ::dc_postgresql::icinga
  include ::dc_postgresql::databases

}
