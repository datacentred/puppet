# == Class: dc_nrpe::checks::postfix
#
class dc_nrpe::checks::postfix {

  dc_nrpe::check { 'check_mailq_postfix':
    path => '/usr/lib/nagios/plugins/check_mailq',
    args => '-M postfix -w 10 -c 30',
  }

}
