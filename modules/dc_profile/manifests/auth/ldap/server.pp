# Class: dc_profile::auth::ldap::server
#
# LDAP master server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::auth::ldap::server {
  include ::ldap::server
  contain 'ldap::server'
}
