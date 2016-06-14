# == Class: dc_profile::db::postgresql_master
#
class dc_profile::db::postgresql_master {

  include ::dc_postgresql
  include ::dc_postgresql::databases
  include ::dc_postgresql::repmgr
  include ::dc_postgresql::icinga
  include ::dc_postgresql::backup

}
