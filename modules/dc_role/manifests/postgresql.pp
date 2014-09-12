# Class: dc_role::postgresql
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
class dc_role::postgresql {

  contain dc_profile::db::postgresql

}
