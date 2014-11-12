# == Class: dc_nrpe::glance
#
class dc_nrpe::glance {

  dc_nrpe::check { 'check_glance_registry_netstat':
    path   => '/usr/local/bin/check_glance-registry.sh',
    source => 'puppet:///modules/dc_nrpe/check_glance-registry.sh',
    sudo   => true,
  }

  dc_nrpe::check { 'check_glance_api_proc':
    path => '/usr/lib/nagios/plugins/check_procs',
    args => '-w 2: -u glance -a glance-api',
  }

  dc_nrpe::check { 'check_glance_registry_proc':
    path => '/usr/lib/nagios/plugins/check_procs',
    args => '-w 2: -u glance -a glance-registry',
  }

}
