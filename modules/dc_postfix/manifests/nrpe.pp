# == Class: dc_postfix::nrpe
#
class dc_postfix::nrpe {

  file { '/etc/nagios/nrpe.d/check_mailq_postfix.cfg':
    ensure  => present,
    content => 'command[check_mailq_postfix]=/usr/lib/nagios/plugins/check_mailq -M postfix -w 10 -c 30',
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server'],
  }

}
