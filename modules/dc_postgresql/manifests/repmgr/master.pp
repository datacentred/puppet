# == Class: dc_postgresql::repmgr::master
#
class dc_postgresql::repmgr::master {

  contain ::dc_postgresql::repmgr::master::db
  contain ::dc_postgresql::repmgr::master::configure

  # Ensure the database is up and running before configuring repmgr further
  Class['::dc_postgresql::repmgr'] ->
  Class['::dc_postgresql::repmgr::master']

  # Install the control database before adding to the cluster
  Class['::dc_postgresql::repmgr::master::db'] ->
  Class['::dc_postgresql::repmgr::master::configure']

}
