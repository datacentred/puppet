# == Class: dc_nrpe::ceilometer_compute
#
class dc_nrpe::ceilometer_compute {

  dc_nrpe::check { 'check_ceilometer_compute_proc':
    path => '/usr/lib/nagios/plugins/check_procs',
    args => '-c 1: -u ceilometer -a ceilometer-agent-compute',
  }

}
