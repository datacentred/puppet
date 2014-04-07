# Class: dc_profile::auth::ldap::master
#
# Set the root password of the host
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