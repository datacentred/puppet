# == Class: ::dc_docker::client
#
# Installs Docker and configures certificates for use with
# DataCentred's private registry
#
class dc_docker::client {

  include ::docker

  $_dcertpath = '/etc/docker/certs.d/registry.datacentred.services:5000'

  if versioncmp($::puppetversion, '4.0.0') >= 0 {
    $_pcertpath = '/etc/puppetlabs/puppet/ssl'
  } else {
    $_pcertpath = '/var/lib/puppet/ssl'
  }

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  file { '/etc/docker/certs.d':
    ensure  => directory,
  }

  file { $_dcertpath:
    ensure => directory,
  }

  file { "${_dcertpath}/client.key":
    source => "file:///${_pcertpath}/private_keys/${::fqdn}.pem",
  }

  file { "${_dcertpath}/client.cert":
    source => "file:///${_pcertpath}/certs/${::fqdn}.pem",
  }

  file { "${_dcertpath}/ca.crt":
    source => "file:///${_pcertpath}/certs/ca.pem",
  }

  # Ensure /etc/docker is created before we create the child directory
  Class['::docker::install'] -> File['/etc/docker/certs.d']

  # Restart the docker service when client configuration changes
  Class['::dc_docker::client'] ~> Class['::docker::service']

}
