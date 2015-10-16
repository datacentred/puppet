# Class: dc_profile::auth::radius::server
#
# Radius server
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
      secret  => $secret,
  }

  exec { 'puppet_radius_group':
    unless  => '/usr/bin/getent group puppet | /usr/bin/cut -d: -f4 | /bin/grep -q freerad',
    command => '/usr/sbin/usermod -a -G puppet freerad',
    require => Package['freeradius'],
  }

}
