# == Class: dc_nrpe::nova_compute
#
class dc_nrpe::nova_compute {

  dc_nrpe::check { 'check_nova_compute_netstat':
    path   => '/usr/local/bin/check_nova-compute.sh',
    source => 'puppet:///modules/dc_nrpe/check_nova-compute.sh',
    sudo   => true,
  }

  dc_nrpe::check { 'check_nova_compute_proc':
    path => '/usr/lib/nagios/plugins/check_procs',
    args => '-c 1: -u nova -a nova-compute',
  }

}
