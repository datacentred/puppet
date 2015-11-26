# == Class: dc_nrpe::checks::neutron_routers
#
class dc_nrpe::checks::neutron_routers (
  $username    = undef,
  $password    = undef,
  $auth_url    = undef,
  $tenant_name = undef,
){

  dc_nrpe::check { 'check_neutron_routers':
    path   => '/usr/local/bin/check_neutron_routers.py',
    args   => "-u ${username} -p ${password} -a ${auth_url} -t ${tenant_name}",
    source => 'puppet:///modules/dc_nrpe/check_neutron_routers.py'
  }

}
