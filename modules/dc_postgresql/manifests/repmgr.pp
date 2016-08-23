# == Class: dc_postgresql::repmgr
#
# Installs and configures repmgr and initialises streaming replication
#
# === Parameters
#
# [*role*]
#   Specifies whether this is a master or slave (hot standby)
#
# [*nodemap*]
#   Hash of FQDN to ID pairs
#
# [*ssh_public_key*]
#   Public key for replication synchronisation
#
# [*ssh_private_key*]
#   Private key for replication synchronisation
#
# [*Cluster_master*]
#   Hostname of the cluster master
#
# [*cluster_name*]
#   Textual name of the cluster
#
# [*version*]
#   Should match that of postgresql
#
# [*home*]
#   Postgres home directory
#
class dc_postgresql::repmgr (
  $role,
  $nodemap,
  $ssh_public_key,
  $ssh_private_key,
  $cluster_master,
  $cluster_name = 'test',
  $version = '9.5',
  $home = '/var/lib/postgresql',
) {

  include ::dc_postgresql::repmgr::install
  include ::dc_postgresql::repmgr::configure
  include ::dc_postgresql::repmgr::cluster_connections

  case $role {
    'master': {
      include ::dc_postgresql::repmgr::master
    }
    'slave': {
      include ::dc_postgresql::repmgr::slave
      include ::dc_postgresql::repmgr::slave::local_connection
    }
    default: {
      err("dc_postgresql::repmgr: illegal role '${role}'")
    }
  }

  # Ensure the repmgr preload libraries are installed before configuring postgres
  Class['::dc_postgresql::repmgr::install'] -> Class['::dc_postgresql::install']

  # Ensure /var/lib/postgresql is created before configuring common repmgr configs/ssh
  Class['::dc_postgresql::install'] -> Class['::dc_postgresql::repmgr::configure']
}
