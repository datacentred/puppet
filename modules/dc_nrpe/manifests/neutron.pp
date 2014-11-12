# == Class: dc_nrpe::neutron
#
class dc_nrpe::neutron (
  $keystone_port,
  $os_api_host,
  $neutron_api_port,
  $keystone_icinga_tenant,
  $keystone_icinga_password,
  $keystone_icinga_user,
) {

  dc_nrpe::check { 'check_neutron_server_netstat':
    path   => '/usr/lib/nagios/plugins/check_neutron-server.sh',
    source => 'puppet:///modules/dc_nrpe/check_neutron-server.sh',
    args   => "-H https://${os_api_host}:${keystone_port}/v2.0 -E https://${os_api_host}:${neutron_api_port}/v2.0 -T ${keystone_icinga_tenant} -U ${keystone_icinga_user} -P ${keystone_icinga_password}",
    sudo   => true,
  }

  dc_nrpe::check { 'check_neutron_server':
    path => '/usr/lib/nagios/plugins/check_procs',
    args => '-c 1: -u neutron -a /usr/bin/neutron-server',
  }

}
