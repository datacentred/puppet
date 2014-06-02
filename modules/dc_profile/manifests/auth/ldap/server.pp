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

  include dc_icinga::hostgroup_ldap

  class { 'ldap::client':
    uri       => 'ldaps://127.0.0.1',
    base      => hiera(ldap::server::suffix),
    ssl       => true,
    ssl_cert  => '/etc/ssl/certs/datacentred-ca.crt',
  }

  $defaults = {
    ensure      => present,
    host        => '127.0.0.1',
    port        => 636,
    base        => hiera(ldap::server::suffix),
    username    => hiera(ldap::server::rootdn),
    password    => hiera(ldap::server::rootpw),
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
