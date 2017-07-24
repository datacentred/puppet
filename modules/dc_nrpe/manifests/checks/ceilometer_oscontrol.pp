# == Class: dc_nrpe::checks::ceilometer_oscontrol
#
class dc_nrpe::checks::ceilometer_oscontrol {

  dc_nrpe::check { 'check_ceilometer_notification_proc':
    path => '/usr/lib/nagios/plugins/check_procs',
    args => '-c 1: -a ceilometer-agent-notification',
  }

  dc_nrpe::check { 'check_ceilometer_collector_proc':
    path => '/usr/lib/nagios/plugins/check_procs',
    args => '-c 1: -a ceilometer-collector',
  }

}
