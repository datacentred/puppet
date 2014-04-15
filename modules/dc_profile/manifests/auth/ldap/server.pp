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
  include ::dc_ssl
  include ::dc_ssl::slapd
  include ::ldap::server

  contain 'dc_ssl'
  contain 'dc_ssl::slapd'
  contain 'ldap::server'

  Class['dc:ssl'] ~> Class['ldap::server::service']
  Class['dc_ssl::slapd'] ~> Class['ldap::server::service']
}
