# Class: dc_puppet::master::install
#
# Puppet master package installation
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_puppet::master::install {

  include dc_puppet::params

  $ssl_valid_file = '/var/lib/puppet/ssl_valid'

  # Delete the old SSL certs only if we've not provisioned
  exec { 'dc_puppet::master::install delete certs':
    command => "rm -rf ${dc_puppet::params::ssldir}",
    path    => '/bin',
    creates => $ssl_valid_file,
    before  => Package[$dc_puppet::params::master_package],
  }

  package { $dc_puppet::params::master_package:
    ensure => $dc_puppet::params::version,
  }

  # Flag that we have provisioned so that the exec above
  # is not run on subsequent runs
  file { $ssl_valid_file:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    require => Package[$dc_puppet::params::master_package],
  }

}
