# Class: dc_bmc::icinga
#
# Installs NRPE checks
#
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
class dc_bmc::icinga {

  file { '/usr/local/bin/check_bmc':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
    content => template('dc_bmc/check_bmc.erb'),
  }

  dc_nrpe::check { 'check_bmc':
    path    => '/usr/local/bin/check_bmc',
    sudo    => true,
    require => File['/usr/local/bin/check_bmc'],
  }

}
