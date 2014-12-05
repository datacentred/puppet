# == Class: dc_postgresql::slave
#
class dc_postgresql::slave {

  include ::dc_postgresql::install
  include ::dc_postgresql::config
  include ::dc_postgresql::repmgr::config
  include ::dc_postgresql::repmgr::slave
  include ::dc_postgresql::repmgr::local_connection
  include ::dc_postgresql::slave::standby_sync
  include ::dc_postgresql::keys::cluster
  include ::dc_postgresql::keys::slave
  include ::dc_postgresql::icinga

}
