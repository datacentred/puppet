# == Class: dc_profile::ci::jenkins
#
class dc_profile::ci::jenkins {

  # Required for LDAPS support to trust the server certificate
  ca_certificate { 'puppet-ca':
    source => '/var/lib/puppet/ssl/certs/ca.pem',
    java   => true,
  }

}
