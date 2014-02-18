# Class: dc_role::platformservices_database
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
class dc_role::platformservices_database {

  contain dc_profile::db::coredb
  contain dc_profile::db::coredb_mysql

}
