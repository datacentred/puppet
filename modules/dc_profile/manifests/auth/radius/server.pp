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

  radius::vhost { 'datacentred':
    authorize    => ['ldap'],
    authenticate => ['ldap'],
    post_auth    => ['ldap'],
  }

  radius::vhost::listen {
    'dc_auth':
      vhost  => 'datacentred',
      ipaddr => '0.0.0.0',
      port   => '0',
      type   => 'auth';
    'dc_acct':
      vhost  => 'datacentred',
      ipaddr => '0.0.0.0',
      port   => '0',
      type   => 'acct',
  }

  radius::vhost::client {
    'datacentred':
      vhost   => 'datacentred',
      ipaddr  => '0.0.0.0',
      netmask => '0',
      secret  => 'kJvRRR.6';
  }

  @@dns_resource { "radius.${::domain}/CNAME":
    rdata => $::fqdn,
  }
}
