# == Class: dc_nrpe::ceilometer_oscontrol
#
class dc_nrpe::ceilometer_oscontrol {

  dc_nrpe::check { 'check_ceilometer_notification_proc':
    path => '/usr/lib/nagios/plugins/check_procs',
    args => '-c 1: -u ceilometer -a ceilometer-agent-notification',
  }

  dc_nrpe::check { 'check_ceilometer_central_proc':
    path => '/usr/lib/nagios/plugins/check_procs',
    args => '-c 1: -u ceilometer -a ceilometer-agent-central',
  }

  dc_nrpe::check { 'check_ceilometer_collector_proc':
    path => '/usr/lib/nagios/plugins/check_procs',
    args => '-c 1: -u ceilometer -a ceilometer-collector',
  }

  dc_nrpe::check { 'check_ceilometer_api_proc':
    path => '/usr/lib/nagios/plugins/check_procs',
    args => '-c 1: -u ceilometer -a ceilometer-api',
  }

}
