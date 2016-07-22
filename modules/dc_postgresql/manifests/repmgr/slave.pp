# == Class: dc_postgresql::repmgr::slave
#
class dc_postgresql::repmgr::slave {

  contain ::dc_postgresql::repmgr::slave::configure

  # Ensure the database is up and running before configuring repmgr further
  Class['::dc_postgresql::repmgr::configure'] ->
  Class['::dc_postgresql::repmgr::slave']

}
