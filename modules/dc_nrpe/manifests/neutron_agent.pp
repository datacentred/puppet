# == Class: dc_nrpe::neutron_agent
#
class dc_nrpe::neutron_agent {

  file { '/etc/nagios/nrpe.d/neutron_agent.cfg':
    ensure  => present,
    source  => 'puppet:///modules/dc_nrpe/neutron_agent.cfg',
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server'],
  }

}
