# == Class: dc_nrpe::checks::postfix
#
class dc_nrpe::checks::postfix (
  $warn,
  $crit,
){

  dc_nrpe::check { 'check_mailq_postfix':
    path => '/usr/lib/nagios/plugins/check_mailq',
    args => "-M postfix -w ${warn} -c ${crit}",
  }

}
