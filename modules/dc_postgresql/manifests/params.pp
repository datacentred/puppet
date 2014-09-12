# == Class: dc_postgresql::params
#
# Parameter container class.  Override with hiera
# data bindings
#
# === Parameters
#
# [*postgres_password*]
#   Password for the postgres account
#
# [*backup_path*]
#   Path to the barman backup directory
#
# [*backup_server*]
#   Hostname of the barman backup server
#
# [*cluster_master_node*]
#   Hostname of the master cluster node
#
# [*cluster_standby_nodes*]
#   Array of hostnames of the standby cluster nodes
#
# [*cluster_name*]
#   Identifier for the cluster
#
# [*listen_addresses*]
#   Addresses the postgresql server should listen on
#
# [*ip_mask_allow_all_users*]
#
# [*ip_mask_deny_postgres_user*]
#
class dc_postgresql::params (
  $postgres_password,
  $pgdata,
  $backup_path,
  $backup_server,
  $cluster_name,
  $cluster_master_node,
  $cluster_standby_nodes = [],
  $listen_addresses = '*',
  $ip_mask_allow_all_users = '0.0.0.0/0',
  $ip_mask_deny_postgres_user = '0.0.0.0/32',
  $databases = {},
) {

  if $caller_module_name != $module_name {
    fail("${name} is private")
  }

}
