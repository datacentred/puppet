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
  include ::dc_ldap
  include ::ldap::server

  contain 'dc_ssl'
  contain 'dc_ssl::slapd'
  contain 'ldap::server'

  Class['ldap::server::install'] -> Class['dc_ldap'] ~> Class['ldap::server::service']
  Class['dc_ssl'] ~> Class['ldap::server::service']
  Class['dc_ssl::slapd'] ~> Class['ldap::server::service']

  @@dns_resource { "ldap.${::domain}/CNAME":
    rdata => $::fqdn,
  }
}
