# == Class: dc_nrpe::nova_server
#
class dc_nrpe::nova_server {

  dc_nrpe::check { 'check_nova_scheduler_netstat':
    path   => '/usr/local/bin/check_nova-scheduler.sh',
    source => 'puppet:///modules/dc_nrpe/check_nova-scheduler.sh',
    sudo   => true,
  }

  dc_nrpe::check { 'check_nova_conductor_netstat':
    path   => '/usr/local/bin/check_nova-conductor.sh',
    source => 'puppet:///modules/dc_nrpe/check_nova-conductor.sh',
    sudo   => true,
  }

  dc_nrpe::check { 'check_nova_consoleauth_netstat':
    path   => '/usr/local/bin/check_nova-consoleauth.sh',
    source => 'puppet:///modules/dc_nrpe/check_nova-consoleauth.sh',
    sudo   => true,
  }

  dc_nrpe::check { 'check_nova_conductor':
    path => '/usr/lib/nagios/plugins/check_procs',
    args => '-c 1: -u nova -a nova-conductor',
  }

  dc_nrpe::check { 'check_nova_scheduler':
    path => '/usr/lib/nagios/plugins/check_procs',
    args => '-c 1: -u nova -a nova-scheduler',
  }

  dc_nrpe::check { 'check_nova_consoleauth':
    path => '/usr/lib/nagios/plugins/check_procs',
    args => '-c 1: -u nova -a nova-consoleauth',
  }

  dc_nrpe::check { 'check_nova_cert':
    path => '/usr/lib/nagios/plugins/check_procs',
    args => '-c 1: -u nova -a nova-cert',
  }

  dc_nrpe::check { 'check_nova_vncproxy':
    path => '/usr/lib/nagios/plugins/check_procs',
    args => '-c 1: -u nova -a nova-novncproxy',
  }

}
