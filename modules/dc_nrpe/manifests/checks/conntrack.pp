# == Class: dc_nrpe::checks::conntrack
#
class dc_nrpe::checks::conntrack {

  dc_nrpe::check { 'check_conntrack':
    path   => '/usr/lib/nagios/plugins/check_conntrack',
    source => 'puppet:///modules/dc_nrpe/check_conntrack',
    args   => '80 90',
  }

}
