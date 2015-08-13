# == Class: dc_nrpe::checks::lsyncd
#
class dc_nrpe::checks::lsyncd {

  dc_nrpe::check { 'check_lsyncd':
    path => '/usr/lib/nagios/plugins/check_procs',
    args => '-c 1: -a lsyncd',
  }

}
