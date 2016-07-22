# == Class: dc_postgresql::repmgr::cluster_connections
#
# Allows cluster connections to nodes
#
class dc_postgresql::repmgr::cluster_connections {

  $_nodes = keys($::dc_postgresql::repmgr::nodemap)

  # And allow replication and repmgr database access
  dc_postgresql::repmgr::cluster_connection { $_nodes: }

}
