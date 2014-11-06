# Class: dc_nrpe::nova_compute
#
# Nova compute specific nrpe configuration
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
class dc_nrpe::nova_compute {

  sudo::conf { 'check_nova_compute_netstat':
    priority    => 10,
    content     => 'nagios ALL=NOPASSWD:/usr/lib/nagios/plugins/check_nova-compute.sh',
  }

  file { '/usr/lib/nagios/plugins/check_nova-compute.sh':
    ensure  => file,
    source  => 'puppet:///modules/dc_nrpe/check_nova-compute.sh',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  file { '/etc/nagios/nrpe.d/nova_compute.cfg':
    ensure  => present,
    source  => 'puppet:///modules/dc_nrpe/nova_compute.cfg',
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server'],
  }


}
