# Class: dc_riemann
#
# Install and configure riemann
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_riemann {

  $sysmailaddress = hiera(sysmailaddress)
  $riemann_config_dir = '/etc/riemann.conf.d'

  class { 'riemann':
    config_file => '/etc/riemann.config',
    require     => File['/etc/riemann.config'],
  }

  class { 'riemann::dash': }

  file { '/etc/riemann.config':
    ensure  => file,
    content => template('dc_riemann/riemann.config.erb'),
  }

  file { '/etc/riemann.conf.d':
    ensure => directory,
    owner  => 'riemann',
    group  => 'riemann',
  }
}

