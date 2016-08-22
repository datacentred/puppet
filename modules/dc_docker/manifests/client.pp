# == Class: ::dc_docker::client
#
# Installs Docker and configures certificates for use with
# DataCentred's private registry
#
class dc_docker::client {
  include ::docker

  $_dcertpath = '/etc/docker/certs.d/registry.datacentred.services:5000'
  $_pcertpath = '/var/lib/puppet/ssl'

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  file { '/etc/docker/certs.d':
    ensure  => directory,
    require => Package['docker-engine'],
  }

  file { $_dcertpath:
    ensure => directory,
  }

  file { "${_dcertpath}/client.key":
    source => "file:///${_pcertpath}/private_keys/${::fqdn}.pem",
    notify => Service['docker'],
  }

  file { "${_dcertpath}/client.cert":
    source => "file:///${_pcertpath}/certs/${::fqdn}.pem",
    notify => Service['docker'],
  }

  file { "${_dcertpath}/ca.crt":
    source => "file:///${_pcertpath}/certs/ca.pem",
    notify => Service['docker'],
  }

}
