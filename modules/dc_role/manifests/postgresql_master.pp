# Class: dc_role::postgresql_master
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
class dc_role::postgresql_master inherits dc_role {

  contain dc_profile::db::postgresql_master
  contain dc_profile::db::duplicity_mariadb
  contian dc_backup::gpg_keys

}
