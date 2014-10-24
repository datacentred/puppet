# Class: dc_role::graphite
#
# Realtime graph plotting role
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::graphite inherits dc_role {

  contain dc_profile::perf::network_weathermap
  contain dc_profile::net::phpipam
  contain dc_profile::db::coredb_mysql

}
