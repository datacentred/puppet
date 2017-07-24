# == Class: dc_icinga2::services::heat_api_proc
#
# Checks the heat-api process is running
#
class dc_icinga2::services::heat_api_proc {

  icinga2::object::apply_service { 'heat_api_proc':
    import        => 'generic-service',
    check_command => 'procs',
    vars          => {
      'procs_critical' => '1:',
      'procs_argument' => 'heat-api',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_control"',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
