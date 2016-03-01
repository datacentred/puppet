# == Class: dc_icinga2::services::openstack
#
# Service checks for OpenStack components
#
class dc_icinga2::services::openstack (
  $tenant = 'icinga',
  $username = 'icinga',
  $password = 'password',
) {

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
    check_command => 'openstack-service',
    vars          => {
      'openstack_service_process' => 'nova-compute',
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
    check_command => 'openstack-service',
    vars          => {
      'openstack_service_process' => 'nova-consoleauth',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_control"',
  }

  icinga2::object::apply_service { 'nova scheduler':
    import        => 'generic-service',
    check_command => 'openstack-service',
    vars          => {
      'openstack_service_process' => 'nova-scheduler',
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

  icinga2::object::apply_service { 'neutron server':
    import        => 'generic-service',
    check_command => 'openstack-service',
    vars          => {
      'openstack_service_process' => 'neutron-server',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_control"',
  }

  icinga2::object::apply_service { 'neutron api':
    import        => 'generic-service',
    check_command => 'neutron-api',
    vars          => {
      'neutron_api_tenant'   => $tenant,
      'neutron_api_username' => $username,
      'neutron_api_password' => $password,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_control"',
  }

  icinga2::object::apply_service { 'neutron dhcp agent':
    import        => 'generic-service',
    check_command => 'procs',
    vars          => {
      'procs_critical' => '1:',
      'procs_user'     => 'neutron',
      'procs_argument' => 'neutron-dhcp-agent',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_network"',
  }

  icinga2::object::apply_service { 'neutron metadata agent':
    import        => 'generic-service',
    check_command => 'procs',
    vars          => {
      'procs_critical' => '1:',
      'procs_user'     => 'neutron',
      'procs_argument' => 'neutron-ns-metadata-proxy',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_network"',
  }

  icinga2::object::apply_service { 'neutron vpnaas agent':
    import        => 'generic-service',
    check_command => 'procs',
    vars          => {
      'procs_critical' => '1:',
      'procs_user'     => 'neutron',
      'procs_argument' => 'neutron-vpn-agent',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_network"',
  }

  icinga2::object::apply_service { 'neutron lbaas agent':
    import        => 'generic-service',
    check_command => 'procs',
    vars          => {
      'procs_critical' => '1:',
      'procs_user'     => 'neutron',
      'procs_argument' => 'neutron-lbaas-agent',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_network"',
  }

  icinga2::object::apply_service { 'neutron metering agent':
    import        => 'generic-service',
    check_command => 'procs',
    vars          => {
      'procs_critical' => '1:',
      'procs_user'     => 'neutron',
      'procs_argument' => 'neutron-metering-agent',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_network"',
  }

  icinga2::object::apply_service { 'neutron openvswitch agent':
    import        => 'generic-service',
    check_command => 'procs',
    vars          => {
      'procs_critical' => '1:',
      'procs_user'     => 'neutron',
      'procs_argument' => 'neutron-openvswitch-agent',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_compute" || host.vars.role == "openstack_network"',
  }

  icinga2::object::apply_service { 'openvswitch':
    import        => 'generic-service',
    check_command => 'procs',
    vars          => {
      'procs_critical' => '1:',
      'procs_command'  => 'ovs-vswitchd',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_compute" || host.vars.role == "openstack_network"',
  }

  icinga2::object::apply_service { 'openvswitch database':
    import        => 'generic-service',
    check_command => 'procs',
    vars          => {
      'procs_critical' => '1:',
      'procs_command'  => 'ovsdb-server',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_compute" || host.vars.role == "openstack_network"',
  }

  icinga2::object::apply_service { 'ceilometer agent':
    import        => 'generic-service',
    check_command => 'procs',
    vars          => {
      'procs_critical' => '1:',
      'procs_user'     => 'ceilometer',
      'procs_argument' => 'ceilometer-agent-compute',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_compute"',
  }

  icinga2::object::apply_service { 'ceilometer notification agent':
    import        => 'generic-service',
    check_command => 'procs',
    vars          => {
      'procs_critical' => '1:',
      'procs_user'     => 'ceilometer',
      'procs_argument' => 'ceilometer-agent-notification',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_control"',
  }

  icinga2::object::apply_service { 'ceilometer central agent':
    import        => 'generic-service',
    check_command => 'procs',
    vars          => {
      'procs_critical' => '1:',
      'procs_user'     => 'ceilometer',
      'procs_argument' => 'ceilometer-agent-central',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_control"',
  }

  icinga2::object::apply_service { 'ceilometer collector':
    import        => 'generic-service',
    check_command => 'procs',
    vars          => {
      'procs_critical' => '1:',
      'procs_user'     => 'ceilometer',
      'procs_argument' => 'ceilometer-collector',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_control"',
  }

  icinga2::object::apply_service { 'ceilometer api':
    import        => 'generic-service',
    check_command => 'procs',
    vars          => {
      'procs_critical' => '1:',
      'procs_user'     => 'ceilometer',
      'procs_argument' => 'ceilometer-api',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_control"',
  }

}
