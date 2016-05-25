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
    check_command => 'openstack-service',
    vars          => {
      'openstack_service_process' => 'nova-cert',
      'enable_pagerduty'          => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_control"',
  }

  icinga2::object::apply_service { 'nova compute':
    import        => 'generic-service',
    check_command => 'openstack-service',
    vars          => {
      'openstack_service_process' => 'nova-compute',
      'enable_pagerduty'          => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_compute"',
  }

  icinga2::object::apply_service { 'nova conductor':
    import        => 'generic-service',
    check_command => 'openstack-service',
    vars          => {
      'openstack_service_process' => 'nova-conductor',
      'openstack_service_child'   => true,
      'enable_pagerduty'          => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_control"',
  }

  icinga2::object::apply_service { 'nova consoleauth':
    import        => 'generic-service',
    check_command => 'openstack-service',
    vars          => {
      'openstack_service_process' => 'nova-consoleauth',
      'enable_pagerduty'          => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_control"',
  }

  icinga2::object::apply_service { 'nova scheduler':
    import        => 'generic-service',
    check_command => 'openstack-service',
    vars          => {
      'openstack_service_process' => 'nova-scheduler',
      'enable_pagerduty'          => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_control"',
  }

  icinga2::object::apply_service { 'nova novnc proxy':
    import        => 'generic-service',
    check_command => 'procs',
    vars          => {
      'procs_critical'   => '1:',
      'procs_user'       => 'nova',
      'procs_argument'   => 'nova-novncproxy',
      'enable_pagerduty' => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_control"',
  }

  icinga2::object::apply_service { 'neutron server':
    import        => 'generic-service',
    check_command => 'openstack-service',
    vars          => {
      'openstack_service_process' => 'neutron-server',
      'enable_pagerduty'          => true,
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
      'enable_pagerduty'     => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_control"',
  }

  icinga2::object::apply_service { 'neutron dhcp agent':
    import        => 'generic-service',
    check_command => 'openstack-service',
    vars          => {
      'openstack_service_process' => 'neutron-dhcp-agent',
      'enable_pagerduty'          => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_network"',
  }

  icinga2::object::apply_service { 'neutron metadata agent':
    import        => 'generic-service',
    check_command => 'procs',
    vars          => {
      'procs_critical'   => '1:',
      'procs_user'       => 'neutron',
      'procs_argument'   => 'neutron-metadata-agent',
      'enable_pagerduty' => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_network"',
  }

  icinga2::object::apply_service { 'neutron vpnaas agent':
    import        => 'generic-service',
    check_command => 'openstack-service',
    vars          => {
      'openstack_service_process' => 'neutron-vpn-agent',
      'enable_pagerduty'          => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_network"',
  }

  icinga2::object::apply_service { 'neutron lbaas agent':
    import        => 'generic-service',
    check_command => 'openstack-service',
    vars          => {
      'openstack_service_process' => 'neutron-lbaas-agent',
      'enable_pagerduty'          => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_network"',
  }

  icinga2::object::apply_service { 'neutron metering agent':
    import        => 'generic-service',
    check_command => 'openstack-service',
    vars          => {
      'openstack_service_process' => 'neutron-metering-agent',
      'enable_pagerduty'          => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_network"',
  }

  icinga2::object::apply_service { 'neutron openvswitch agent':
    import        => 'generic-service',
    check_command => 'openstack-service',
    vars          => {
      'openstack_service_process' => 'neutron-openvswitch-agent',
      'enable_pagerduty'          => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_compute" || host.vars.role == "openstack_network"',
  }

  icinga2::object::apply_service { 'openvswitch':
    import        => 'generic-service',
    check_command => 'procs',
    vars          => {
      'procs_critical'   => '1:',
      'procs_command'    => 'ovs-vswitchd',
      'enable_pagerduty' => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_compute" || host.vars.role == "openstack_network"',
  }

  icinga2::object::apply_service { 'openvswitch database':
    import        => 'generic-service',
    check_command => 'procs',
    vars          => {
      'procs_critical'   => '1:',
      'procs_command'    => 'ovsdb-server',
      'enable_pagerduty' => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_compute" || host.vars.role == "openstack_network"',
  }

  icinga2::object::apply_service { 'ceilometer agent':
    import        => 'generic-service',
    check_command => 'openstack-service',
    vars          => {
      'openstack_service_process' => 'ceilometer-agent-compute',
      'enable_pagerduty'          => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_compute"',
  }

  icinga2::object::apply_service { 'ceilometer notification agent':
    import        => 'generic-service',
    check_command => 'openstack-service',
    vars          => {
      'openstack_service_process' => 'ceilometer-agent-notification',
      'enable_pagerduty'          => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_control"',
  }

  icinga2::object::apply_service { 'ceilometer central agent':
    import        => 'generic-service',
    check_command => 'openstack-service',
    vars          => {
      'openstack_service_process' => 'ceilometer-agent-central',
      'enable_pagerduty'          => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_control"',
  }

  icinga2::object::apply_service { 'ceilometer collector':
    import        => 'generic-service',
    check_command => 'openstack-service',
    vars          => {
      'openstack_service_process' => 'ceilometer-collector',
      'enable_pagerduty'          => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_control"',
  }

  icinga2::object::apply_service { 'cinder api':
    import        => 'generic-service',
    check_command => 'openstack-service',
    vars          => {
      'openstack_service_process' => 'cinder-api',
      'openstack_service_child'   => true,
      'enable_pagerduty'          => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_control"',
  }

  icinga2::object::apply_service { 'cinder scheduler':
    import        => 'generic-service',
    check_command => 'openstack-service',
    vars          => {
      'openstack_service_process' => 'cinder-scheduler',
      'enable_pagerduty'          => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_control"',
  }

  icinga2::object::apply_service { 'cinder volume':
    import        => 'generic-service',
    check_command => 'openstack-service',
    vars          => {
      'openstack_service_process' => 'cinder-volume',
      'openstack_service_child'   => true,
      'enable_pagerduty'          => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_control"',
  }

  icinga2::object::apply_service { 'glance api':
    import        => 'generic-service',
    check_command => 'openstack-service',
    vars          => {
      'openstack_service_process' => 'glance-api',
      'openstack_service_child'   => true,
      'enable_pagerduty'          => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_control"',
  }

  icinga2::object::apply_service { 'glance registry':
    import        => 'generic-service',
    check_command => 'procs',
    vars          => {
      'procs_critical'   => '2:',
      'procs_user'       => 'glance',
      'procs_argument'   => 'glance-registry',
      'enable_pagerduty' => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_control"',
  }

  icinga2::object::apply_service { 'keystone':
    import        => 'openstack-service',
    check_command => 'keystone',
    vars          => {
      'keystone_host'     => 'https://compute.datacentred.io:5000/v2.0',
      'keystone_project'  => $tenant,
      'keystone_username' => $username,
      'keystone_password' => $password,
      'keystone_admin'    => true,
      'enable_pagerduty'  => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "monitoring_master"',
  }

  icinga2::object::apply_service { 'glance':
    import        => 'openstack-service',
    check_command => 'glance',
    vars          => {
      'glance_host'      => 'https://compute.datacentred.io:9292',
      'glance_authurl'   => 'https://compute.datacentred.io:5000',
      'glance_project'   => $tenant,
      'glance_username'  => $username,
      'glance_password'  => $password,
      'enable_pagerduty' => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "monitoring_master"',
  }

  icinga2::object::apply_service { 'cinder':
    import        => 'openstack-service',
    check_command => 'cinder',
    vars          => {
      'cinder_host'        => 'https://compute.datacentred.io:5000',
      'cinder_project'     => $tenant,
      'cinder_username'    => $username,
      'cinder_password'    => $password,
      'cinder_volume_name' => 'icinga2',
      'cinder_warning'     => [ 30, 45 ],
      'cinder_critical'    => [ 45, 60 ],
      'cinder_timeout'     => [ 90, 90 ],
      'enable_pagerduty'   => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "monitoring_master"',
  }

  icinga2::object::apply_service { 'nova':
    import        => 'openstack-service',
    check_command => 'nova',
    vars          => {
      'nova_host'          => 'https://compute.datacentred.io:5000',
      'nova_project'       => $tenant,
      'nova_username'      => $username,
      'nova_password'      => $password,
      'nova_flavor'        => 'dc1.1x0',
      'nova_image'         => 'CirrOS 0.3.3',
      'nova_network'       => 'icinga_net',
      'nova_instance_name' => 'icinga2',
      'nova_warning'       => [ 30, 45 ],
      'nova_critical'      => [ 45, 60 ],
      'nova_timeout'       => [ 90, 90 ],
      'enable_pagerduty'   => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "monitoring_master"',
  }

  icinga2::object::apply_service { 'ceilometer':
    import        => 'openstack-service',
    check_command => 'ceilometer',
    vars          => {
      'ceilometer_host'     => 'https://compute.datacentred.io:5000',
      'ceilometer_project'  => $tenant,
      'ceilometer_username' => $username,
      'ceilometer_password' => $password,
      'enable_pagerduty'    => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "monitoring_master"',
  }

  icinga2::object::apply_service { 'openstack keystone':
    import        => 'generic-service',
    check_command => 'http',
    vars          => {
      'http_port'        => 5000,
      'http_ssl'         => true,
      'enable_pagerduty' => true,
    },
    assign_where  => 'host.vars.role == "openstack-endpoint"',
  }

  icinga2::object::apply_service { 'openstack keystone admin':
    import        => 'generic-service',
    check_command => 'http',
    vars          => {
      'http_port'        => 35357,
      'http_ssl'         => true,
      'enable_pagerduty' => true,
    },
    assign_where  => 'host.vars.role == "openstack-endpoint"',
  }

  icinga2::object::apply_service { 'openstack glance':
    import        => 'generic-service',
    check_command => 'http',
    vars          => {
      'http_port'        => 9292,
      'http_ssl'         => true,
      'enable_pagerduty' => true,
    },
    assign_where  => 'host.vars.role == "openstack-endpoint"',
  }

  icinga2::object::apply_service { 'openstack neutron':
    import        => 'generic-service',
    check_command => 'http',
    vars          => {
      'http_port'        => 9696,
      'http_ssl'         => true,
      'enable_pagerduty' => true,
    },
    assign_where  => 'host.vars.role == "openstack-endpoint"',
  }

  icinga2::object::apply_service { 'openstack nova':
    import        => 'generic-service',
    check_command => 'http',
    vars          => {
      'http_port'        => 8774,
      'http_ssl'         => true,
      'enable_pagerduty' => true,
    },
    assign_where  => 'host.vars.role == "openstack-endpoint"',
  }

  icinga2::object::apply_service { 'openstack nova metadata':
    import        => 'generic-service',
    check_command => 'http',
    vars          => {
      'http_port'        => 8775,
      'enable_pagerduty' => true,
    },
    assign_where  => 'host.vars.role == "openstack-endpoint"',
  }

  icinga2::object::apply_service { 'openstack nova ec2':
    import        => 'generic-service',
    check_command => 'tcp',
    vars          => {
      'tcp_port'         => 8773,
      'tcp_ssl'          => true,
      'enable_pagerduty' => true,
    },
    assign_where  => 'host.vars.role == "openstack-endpoint"',
  }

  icinga2::object::apply_service { 'openstack cinder':
    import        => 'generic-service',
    check_command => 'http',
    vars          => {
      'http_port'        => 8776,
      'http_ssl'         => true,
      'enable_pagerduty' => true,
    },
    assign_where  => 'host.vars.role == "openstack-endpoint"',
  }

  icinga2::object::apply_service { 'openstack horizon':
    import        => 'generic-service',
    check_command => 'http',
    vars          => {
      'http_port'        => 443,
      'http_ssl'         => true,
      'enable_pagerduty' => true,
    },
    assign_where  => 'host.vars.role == "openstack-endpoint"',
  }

  icinga2::object::apply_service { 'openstack novnc proxy':
    import        => 'generic-service',
    check_command => 'http',
    vars          => {
      'http_port'        => 6080,
      'http_ssl'         => true,
      'enable_pagerduty' => true,
    },
    assign_where  => 'host.vars.role == "openstack-endpoint"',
  }

  icinga2::object::apply_service { 'openstack ceilometer':
    import        => 'generic-service',
    check_command => 'tcp',
    vars          => {
      'tcp_port'         => 8777,
      'tcp_ssl'          => true,
      'enable_pagerduty' => true,
    },
    assign_where  => 'host.vars.role == "openstack-endpoint"',
  }

  icinga2::object::apply_service { 'openstack heat':
    import        => 'generic-service',
    check_command => 'http',
    vars          => {
      'http_port'        => 8004,
      'http_ssl'         => true,
      'enable_pagerduty' => true,
    },
    assign_where  => 'host.vars.role == "openstack-endpoint"',
  }

  icinga2::object::apply_service { 'openstack cloud formation':
    import        => 'generic-service',
    check_command => 'http',
    vars          => {
      'http_port'        => 8000,
      'http_ssl'         => true,
      'enable_pagerduty' => true,
    },
    assign_where  => 'host.vars.role == "openstack-endpoint"',
  }

}

