# == Class: dc_nrpe::neutron_common
#
class dc_nrpe::neutron_common {

  include sudo

  # Limit the amount of spam that the neutron heartbeat generates
  # See https://bugs.launchpad.net/neutron/+bug/1310571 as an
  # example description
  sudo::conf { 'neutron':
    priority => 10,
    content  => 'Defaults:neutron !requiretty, syslog_badpri=err, syslog_goodpri=info
neutron ALL=(root) NOPASSWD: /usr/bin/neutron-rootwrap',
  }

  file { '/etc/nagios/nrpe.d/neutron_common.cfg':
    ensure => present,
    source => 'puppet://modules/dc_nrpe/neutron_common.cfg',
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server'],
  }

}
