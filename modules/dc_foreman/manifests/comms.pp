# == Class: dc_foreman::comms
#
# Workaround for proxy comms certs
# in Foreman HA
#
class dc_foreman::comms {

  file { '/var/lib/puppet/ssl/certs/foreman_comms.pem':
    ensure => 'link',
    target => "/var/lib/puppet/ssl/certs/${::fqdn}.pem",
  }

  file { '/var/lib/puppet/ssl/private_keys/foreman_comms.pem':
    ensure => 'link',
    target => "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem",
  }

}
