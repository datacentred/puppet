# == Class: dc_profile::ci::jenkins
#
class dc_profile::ci::jenkins {

  include ::puppetdeploy

  # Required for LDAPS support to trust the server certificate
  if versioncmp($::puppetversion, '4.0.0') >= 0 {
    $_cacert = '/etc/puppetlabs/puppet/ssl/certs/ca.pem'
  } else {
    $_cacert = '/var/lib/puppet/ssl/certs/ca.pem'
  }

  ca_certificate { 'puppet-ca':
    source => $_cacert,
    java   => true,
  }

  package { 'jenkins':
    ensure  => '2.7.1',
  }

}
