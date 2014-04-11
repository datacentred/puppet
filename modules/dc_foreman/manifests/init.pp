# Class: dc_foreman
#
# Foreman
#
# Parameters:
#
# Actions:
#
# Requires: puppetlabs/stdlib
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_foreman (
) {

  file { '/usr/share/foreman/app/assets/javascripts/host_edit.js':
    owner   => 'foreman',
    group   => 'foreman',
    mode    => '0640',
    content => template('dc_foreman/host_edit.js'),
  }

  file { '/usr/share/foreman/app/views/hosts/_unattended.html.erb':
    owner   => 'foreman',
    group   => 'foreman',
    mode    => '0640',
    source  => 'puppet:///dc_foreman/_unattended.html.erb',
  }

}
