# == Class: dc_profile::ci::jenkins
#
class dc_profile::ci::jenkins {

  include ::puppetdeploy

  # Required for LDAPS support to trust the server certificate
  ca_certificate { 'puppet-ca':
    source => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
    java   => true,
  }

  package { 'jenkins':
    ensure  => installed,
  }

}
