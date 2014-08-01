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
class dc_profile::auth::ldap::server (
  $suffix,
  $rootdn,
  $rootpw,
) {
  include ::dc_ssl
  include ::dc_ssl::slapd
  include ::dc_ldap
  include ::ldap::server
  include ::ldap::client

  contain 'dc_ssl'
  contain 'dc_ssl::slapd'
  contain 'ldap::server'
  contain 'ldap::client'

  Class['ldap::server::install'] -> Class['dc_ldap'] ~> Class['ldap::server::service']
  Class['dc_ssl'] ~> Class['ldap::server::service']
  Class['dc_ssl::slapd'] ~> Class['ldap::server::service']

  @@dns_resource { "ldap.${::domain}/CNAME":
    rdata => $::fqdn,
  }

  include dc_icinga::hostgroup_ldap

  $defaults = {
    ensure      => present,
    host        => '127.0.0.1',
    port        => 636,
    base        => $suffix,
    username    => $rootdn,
    password    => $rootpw,
    self_signed => true,
  }

  create_resources(ldap_entry, hiera(ldap_schema), $defaults)
  create_resources(ldap_entry, hiera(ldap_users), $defaults)
  create_resources(ldap_entry, hiera(ldap_groups), $defaults)

  Ldap_entry <| tag == 'root' |> ->
  Ldap_entry <| tag == 'organizational_unit' |> ->
  Ldap_entry <| tag == 'user' |> ->
  Ldap_entry <| tag == 'group_of_names' |>

}
