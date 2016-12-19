# == Class: dc_nrpe::checks::common
#
class dc_nrpe::checks::common (
  $check_users = { warn => '5', crit   => '10' },
  $check_disks = { warn => '10%', crit => '5%' },
) {

  $python_yaml = $::operatingsystem ? {
    /(RedHat|CentOS)/ => 'PyYAML',
    /(Debian|Ubuntu)/ => 'python-yaml',
  }

  ensure_packages($python_yaml)

  $lw1  = $::processorcount * 8
  $lc1  = $::processorcount * 10
  $lw5  = $::processorcount * 5
  $lc5  = $::processorcount * 8
  $lw15 = $::processorcount * 3
  $lc15 = $::processorcount * 4

  dc_nrpe::check { 'check_users':
    path => '/usr/lib/nagios/plugins/check_users',
    args => "-w ${check_users[warn]} -c ${check_users[crit]}",
  }

  dc_nrpe::check { 'check_load':
    path => '/usr/lib/nagios/plugins/check_load',
    args => "-w ${lw1},${lw5},${lw15} -c ${lc1},${lc5},${lc15}",
  }

  dc_nrpe::check { 'check_all_disks':
    path => '/usr/lib/nagios/plugins/check_disk',
    args => "-w ${check_disks[warn]} -c ${check_disks[crit]} --exclude-type=tracefs",
    sudo => true,
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

  dc_nrpe::check { 'check_memory':
    path => '/usr/lib/nagios/plugins/check_memory',
    args => '-w 1000000000: -c 500000000:',
  }

}
