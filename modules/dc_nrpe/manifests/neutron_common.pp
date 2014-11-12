# == Class: dc_nrpe::neutron_common
#
class dc_nrpe::neutron_common {

  dc_nrpe::check { 'check_neutron_vswitch_agent':
    path => '/usr/lib/nagios/plugins/check_procs',
    args => '-c 1 -u neutron -a neutron-openvswitch-agent',
  }

  dc_nrpe::check { 'check_ovswitch_proc':
    path => '/usr/lib/nagios/plugins/check_procs',
    args => '-w 1: -C ovs-vswitchd',
  }

  dc_nrpe::check { 'check_ovswitch_server_proc':
    path => '/usr/lib/nagios/plugins/check_procs',
    args => '-w 1: -C ovsdb-server',
  }

}
