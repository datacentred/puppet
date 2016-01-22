# == Class: dc_icinga2::services::openstack
#
# Service checks for OpenStack components
#
class dc_icinga2::services::openstack {

  Icinga2::Object::Apply_service {
    target => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

  icinga2::object::apply_service { 'nova cert':
    import        => 'generic-service',
    check_command => 'procs',
    vars          => {
      'procs_critical' => '1:',
      'procs_user'     => 'nova',
      'procs_argument' => 'nova-cert',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_control"',
  }

  icinga2::object::apply_service { 'nova compute':
    import        => 'generic-service',
    check_command => 'nova-service',
    vars          => {
      'nova_service_process' => 'nova-compute',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_compute"',
  }

  icinga2::object::apply_service { 'nova conductor':
    import        => 'generic-service',
    check_command => 'procs',
    vars          => {
      'procs_critical' => '1:',
      'procs_user'     => 'nova',
      'procs_argument' => 'nova-conductor',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_control"',
  }

  icinga2::object::apply_service { 'nova consoleauth':
    import        => 'generic-service',
    check_command => 'nova-service',
    vars          => {
      'nova_service_process' => 'nova-consoleauth',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_control"',
  }

  icinga2::object::apply_service { 'nova scheduler':
    import        => 'generic-service',
    check_command => 'nova-service',
    vars          => {
      'nova_service_process' => 'nova-scheduler',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_control"',
  }

  icinga2::object::apply_service { 'nova novnc proxy':
    import        => 'generic-service',
    check_command => 'procs',
    vars          => {
      'procs_critical' => '1:',
      'procs_user'     => 'nova',
      'procs_argument' => 'nova-novncproxy',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_control"',
  }

}
