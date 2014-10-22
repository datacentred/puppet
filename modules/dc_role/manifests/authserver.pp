# Class: dc_role::authserver
#
# Centralised authentication server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::authserver inherits dc_role {
  contain dc_profile::auth::ldap::server
  contain dc_profile::auth::radius::server
  contain dc_profile::net::juniper_backups
}
