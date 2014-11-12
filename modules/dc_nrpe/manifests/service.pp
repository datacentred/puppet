# == Class: dc_nrpe::service
#
class dc_nrpe::service {

  service { 'nagios-nrpe-server':
    ensure  => stopped,
    enable  => false,
  }

  xinetd::service { 'nrpe':
    server                  => '/usr/sbin/nrpe',
    port                    => '5666',
    flags                   => 'REUSE',
    service_type            => 'UNLISTED',
    socket_type             => 'stream',
    wait                    => 'no',
    user                    => 'nagios',
    group                   => 'nagios',
    server_args             => '-c /etc/nagios/nrpe.cfg --inetd',
    log_on_success_operator => '-=',
    log_on_success          => 'PID HOST USERID EXIT DURATION TRAFFIC',
    log_on_failure          => 'USERID',
    disable                 => 'no',
    only_from               => $dc_nrpe::allowed_hosts,
  }

}
