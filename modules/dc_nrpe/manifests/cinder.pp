# == Class: dc_nrpe::cinder
#
class dc_nrpe::cinder {

  dc_nrpe::check { 'check_cinder_scheduler_proc':
    path => '/usr/lib/nagios/plugins/check_procs',
    args => '-c 1: -u cinder -a cinder-scheduler',
  }

  dc_nrpe::check { 'check_cinder_volume_proc':
    path => '/usr/lib/nagios/plugins/check_procs',
    args => '-c 1: -u cinder -a cinder-volume',
  }

  dc_nrpe::check { 'check_cinder_api_proc':
    path => '/usr/lib/nagios/plugins/check_procs':
    args => '-c 1: -u cinder -a cinder-api',
  }

  dc_nrpe::check { 'check_cinder_scheduler_netstat':
    path   => '/usr/local/bin/check_cinder-scheduler.sh',
    source => 'puppet:///modules/dc_nrpe/check_cinder-scheduler.sh',
    sudo   => true,
  }

  dc_nrpe::check { 'check_cinder_volume_netstat':
    path   => '/usr/lib/nagios/plugins/check_cinder-volume.sh',
    source => 'puppet:///modules/dc_nrpe/check_cinder-volume.sh',
    sudo   => true,
  }

}
