# Class: dc_role::postgresql_slave
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
class dc_role::postgresql_slave inherits dc_role {

  contain dc_profile::db::postgresql_slave

}
