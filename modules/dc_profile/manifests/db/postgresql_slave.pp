# == Class: dc_profile::db::postgresql_slave
#
class dc_profile::db::postgresql_slave {

  include ::dc_postgresql
  include ::dc_postgresql::repmgr

  include ::dc_icinga::hostgroup_postgres

  # Ensure the synchronization can occur over ssh
  Class['::dc_ssh'] ->
  Class['::dc_postgresql::repmgr::slave']

}
