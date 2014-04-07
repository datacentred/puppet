# Class: dc_profile::auth::ldap::master
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
class dc_profile::auth::ldap::master {
  include ::ldap::server::master
  contain 'ldap::server::master'
}