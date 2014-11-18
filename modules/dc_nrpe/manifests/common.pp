# == Class: dc_nrpe::common
#
class dc_nrpe::common {

  package { 'python-yaml':
    ensure => installed,
  }

  $lw1  = $::processorcount * 3
  $lw5  = $::processorcount * 2
  $lw15 = $::processorcount
  $lc1  = $::processorcount * 6
  $lc5  = $::processorcount * 4
  $lc15 = $::processorcount * 2

  dc_nrpe::check { 'check_users':
    path => '/usr/lib/nagios/plugins/check_users',
    args => '-w 5 -c 10',
  }

  dc_nrpe::check { 'check_load':
    path => '/usr/lib/nagios/plugins/check_load',
    args => "-w ${lw1},${lw5},${lw15} -c ${lc1},${lc5},${lc15}",
  }

  dc_nrpe::check { 'check_total_procs':
    path => '/usr/lib/nagios/plugins/check_procs',
    args => '-w 400 -c 500',
  }

  dc_nrpe::check { 'check_all_disks':
    path => '/usr/lib/nagios/plugins/check_disk',
    args => '-w 20% -c 10%',
  }

  dc_nrpe::check { 'check_puppetagent':
    path   => '/usr/local/bin/check_puppetagent',
    source => 'puppet:///modules/dc_nrpe/check_puppetagent',
    args   => '-w 1860 -c 2700',
    sudo   => true,
  }

  dc_nrpe::check { 'check_log_courier':
    path   => '/usr/local/bin/check_log_courier',
    source => 'puppet:///modules/dc_nrpe/check_log_courier.py',
    sudo   => true,
  }

}
