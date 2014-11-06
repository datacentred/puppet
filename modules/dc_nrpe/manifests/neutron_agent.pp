# == Class: dc_nrpe::neutron_agent
#
class dc_nrpe::neutron_agent {

  fle { '/etc/nagios/nrpe.d/neutron_agent.cfg':
    ensure  => present,
    source  => 'file:///modules/dc_nrpe/neutron_agent.cfg',
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server'],
  }

}
