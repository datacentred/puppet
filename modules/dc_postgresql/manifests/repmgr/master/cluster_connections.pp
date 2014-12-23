# == Class: dc_postgresql::repmgr::master::cluster_connections
#
# Allows cluster connections to the master node
#
class dc_postgresql::repmgr::master::cluster_connections {

  include ::dc_postgresql::config

  # Get all cluster members
  $cluster_nodes = keys($dc_postgresql::params::nodemap)

  # And allow replication and repmgr database access
  dc_postgresql::repmgr::master::cluster_connection { $cluster_nodes:
  }

}
