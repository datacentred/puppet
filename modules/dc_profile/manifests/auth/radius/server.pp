# Class: dc_profile::auth::radius::server
#
# Radius server§
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::auth::radius::server {
  include ::radius
  include ::radius::module::ldap

  radius::vhost { 'datacentred': }

  @@dns_resource { "radius.${::domain}/CNAME":
    rdata => $::fqdn,
  }
}
