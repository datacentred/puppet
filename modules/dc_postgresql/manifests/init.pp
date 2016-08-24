# == Class: dc_postgresql
#
# Simple wrappers around postgres resources and backups
#
class dc_postgresql (
  $postgres_password = undef,
  $databases = {},
  $config_entries = {},
) {

  include ::postgresql::server

  create_resources('postgresql::server::config_entry', $config_entries)
  create_resources('postgresql::server::db', $databases)

}
