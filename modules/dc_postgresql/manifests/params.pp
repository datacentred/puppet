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
# [*listen_addresses*]
#   Addresses the postgresql server should listen on
#
# [*ip_mask_allow_all_users*]
#
# [*ip_mask_deny_postgres_user*]
#
class dc_postgresql::params (
  $postgres_password,
  $pghome = '/var/lib/postgresql',
  $pgdata,
  $pg_bindir,
  $listen_addresses = '*',
  $ip_mask_allow_all_users = '0.0.0.0/0',
  $ip_mask_deny_postgres_user = '0.0.0.0/32',
  $databases = {},
  $config_entries = {},
) {

  if $caller_module_name != $module_name {
    fail("${name} is private")
  }

}
