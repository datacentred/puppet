# == Class: dc_nrpe::lsyncd
#
class dc_nrpe::lsyncd {

  dc_nrpe::check { 'check_lsyncd':
    path => '/usr/lib/nagios/plugins/check_procs',
    args => '-c 1: -u root -a /usr/bin/lsyncd',
  }

}
