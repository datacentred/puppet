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
class dc_profile::auth::radius::server (
  $cname,
  $secret,
){
  include ::radius
  include ::radius::module::ldap

  radius::vhost { 'datacentred':
    authorize    => ['ldap'],
    authenticate => ['ldap'],
    post_auth    => ['ldap'],
  }

  radius::vhost::listen {
    'dc_authentication':
      vhost  => 'datacentred',
      ipaddr => '0.0.0.0',
      port   => '1812',
      type   => 'auth';
    'dc_accounting':
      vhost  => 'datacentred',
      ipaddr => '0.0.0.0',
      port   => '1813',
      type   => 'acct',
  }

  radius::vhost::client {
    'datacentred':
      vhost   => 'datacentred',
      ipaddr  => '0.0.0.0',
      netmask => '0',
      secret       => $secret,
  }

  if $cname == true {
    @@dns_resource { "radius.${::domain}/CNAME":
      rdata => $::fqdn,
    }
  }
}
