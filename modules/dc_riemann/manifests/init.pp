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

  $sysmailaddress = hiera(sal01_internal_sysmail_address)
  $riemann_config_dir = '/etc/riemann.conf.d'

  class { 'riemann':
    # Specify the latest version, because the package default is old
    version     => '0.2.5',
    config_file => '/etc/riemann.config',
    require     => [ File['/etc/riemann.config'], Package['ruby-dev'] ],
  }

  class { 'riemann::dash':
    host => $::ipaddress,
    require => Class['riemann'],
  }

  package { 'ruby-dev':
    ensure => 'installed',
  }

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

