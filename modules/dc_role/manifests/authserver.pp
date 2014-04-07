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
class dc_role::authserver {
  contain dc_profile::auth::ldap::master
}
