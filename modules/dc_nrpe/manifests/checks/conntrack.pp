# == Class: dc_nrpe::checks::conntrack
#
class dc_nrpe::checks::conntrack {

  dc_nrpe::check { 'check_conntrack':
    path => '/usr/lib/nagios/plugins/check_conntrack',
    args => '80 90',
  }

}
