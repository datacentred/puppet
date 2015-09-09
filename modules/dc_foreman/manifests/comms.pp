# == Class: dc_foreman::comms
#
# In load balanced Foreman configurations with a shared DB cluster
# there is a single setting for the whole cluster to control the
# client SSL certificates used to communicate with the proxies.
# This defaults to $::fqdn, so will work for one node in the cluster
# but not the others.  These symbolic links allow any node in the
# cluster to use thier host specific SSL certificates with a shared
# global configuration setting.
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
