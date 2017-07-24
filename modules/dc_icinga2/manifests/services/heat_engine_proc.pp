# == Class: dc_icinga2::services::heat_engine_proc
#
# Checks the heat-engine process is running
#
class dc_icinga2::services::heat_engine_proc {

  icinga2::object::apply_service { 'heat_engine_proc':
    import        => 'generic-service',
    check_command => 'procs',
    vars          => {
      'procs_critical' => '1:',
      'procs_argument' => 'heat-engine',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_control"',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
