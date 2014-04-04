# Class: dc_puppet::agent::install
#
# Puppet agent installation
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_puppet::agent::install {

  include dc_puppet::params

  package { 'puppet-common':
    ensure => $dc_puppet::params::version,
  }

  package { 'puppet':
    ensure  => $dc_puppet::params::version,
    require => Package['puppet-common'],
  }

}
