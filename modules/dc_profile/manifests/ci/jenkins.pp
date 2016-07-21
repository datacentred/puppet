# == Class: dc_profile::ci::jenkins
#
class dc_profile::ci::jenkins {

  include ::puppetdeploy

  # Required for LDAPS support to trust the server certificate
  ca_certificate { 'puppet-ca':
    source => '/var/lib/puppet/ssl/certs/ca.pem',
    java   => true,
  }

  include apt
  # LTS Jenkins source
  apt::source { 'jenkins':
    location    => 'http://pkg.jenkins-ci.org/debian-stable',
    release     => 'binary/',
    repos       => '',
    key         => '150FDE3F7787E7D11EF4E12A9B7D32F2D50582E6',
    key_source  => 'http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key',
    include_src => false,
  }

  package { 'jenkins':
    ensure  => '2.7.1',
    require => Apt::Source['jenkins']
  }
}
