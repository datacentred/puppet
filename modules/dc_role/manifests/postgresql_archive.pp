# Class: dc_role::postgresql_archive
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
class dc_role::postgresql_archive {

  contain dc_profile::db::postgresql_archive

}
