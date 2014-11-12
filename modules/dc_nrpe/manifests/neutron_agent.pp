# == Class: dc_nrpe::neutron_agent
#
class dc_nrpe::neutron_agent {

  dc_nrpe::check { 'check_neutron_dhcp_agent':
    path => '/usr/lib/nagios/plugins/check_procs',
    args => '-c 1: -u neutron -a /usr/bin/neutron-dhcp-agent',
  }

  dc_nrpe::check { 'check_neutron_metadata_agent':
    path => '/usr/lib/nagios/plugins/check_procs',
    args => '-c 1: -a /usr/bin/neutron-ns-metadata-proxy',
  }

  dc_nrpe::check { 'check_neutron_vpn_agent':
    path => '/usr/lib/nagios/plugins/check_procs',
    args => '-c 1: -u neutron -a /usr/bin/neutron-vpn-agent',
  }

  dc_nrpe::check { 'check_neutron_lbaas_agent',
    path => '/usr/lib/nagios/plugins/check_procs',
    args => '-c 1: -u neutron -a /usr/bin/neutron-lbaas-agent',
  }

  dc_nrpe::check { 'check_neutron_metering_agent':
    path => '/usr/lib/nagios/plugins/check_procs',
    args => '-c 1: -u neutron -a /usr/bin/neutron-metering-agent',
  }

}
