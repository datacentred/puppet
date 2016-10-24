# == Class: dc_profile::ci::rundeck
#
class dc_profile::ci::rundeck(
  $project                   = hiera('dc_profile::ci::rundeck::project'),
){

  validate_string($project)

  # Required for LDAPS support to trust the server certificate
  # Leaving in Puppet 3 support, just in case we ever want to backtest something
  if versioncmp($::puppetversion, '4.0.0') >= 0 {
    $_cacert = '/etc/puppetlabs/puppet/ssl/certs/ca.pem'
  } else {
    $_cacert = '/var/lib/puppet/ssl/certs/ca.pem'
  }

  ca_certificate { 'puppet-ca':
    source => $_cacert,
    java   => true,
  }

  class { 'rundeck':
#    ssl_certfile => $_cacert,
#    ssl_enabled  => true,
    
  }

  rundeck::config::project { $project: }

}
