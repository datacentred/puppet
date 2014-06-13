# Class: dc_nrpe::hpblade
#
# HP Blade specific nrpe configuration
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
class dc_nrpe::hpblade {

  file { '/usr/lib/nagios/plugins/check_hpasm':
    ensure  => file,
    require => Package['nagios-nrpe-server'],
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => 'puppet:///modules/dc_nrpe/check_hpasm',
  }

  sudo::conf { 'check_hpasm':
    priority => 10,
    content  => 'nagios ALL=NOPASSWD:/usr/lib/nagios/plugins/check_hpasm',
  }

  file { '/etc/nagios/nrpe.d/hpasm.cfg':
    ensure  => present,
    content => 'command[check_hpasm]=sudo /usr/lib/nagios/plugins/check_hpasm',
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server'],
  }

}
