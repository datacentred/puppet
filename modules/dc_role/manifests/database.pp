# Class: dc_role::database
#
# Core database used by platform service components
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::database inherits dc_role {

  contain dc_profile::db::coredb
  contain dc_profile::db::coredb_mysql
  contain dc_profile::db::pgbackupclient

}
