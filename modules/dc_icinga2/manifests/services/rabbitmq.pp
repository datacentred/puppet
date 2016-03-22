# == Class: dc_icinga2::services::rabbitmq
#
# Checks RabbitMQ is alive and well
#
class dc_icinga2::services::rabbitmq (
  $username = 'username',
  $password = 'password',
) {

  Icinga2::Object::Apply_service {
    target => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

  icinga2::object::apply_service { 'rabbitmq aliveness':
    import        => 'generic-service',
    check_command => 'rabbitmq-aliveness',
    vars          => {
      'rabbitmq_aliveness_username' => $username,
      'rabbitmq_aliveness_password' => $password,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_data"',
  }

  icinga2::object::apply_service { 'rabbitmq objects':
    import        => 'generic-service',
    check_command => 'rabbitmq-objects',
    vars          => {
      'rabbitmq_objects_username' => $username,
      'rabbitmq_objects_password' => $password,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_data"',
  }

  icinga2::object::apply_service { 'rabbitmq overview':
    import        => 'generic-service',
    check_command => 'rabbitmq-overview',
    vars          => {
      'rabbitmq_overview_username' => $username,
      'rabbitmq_overview_password' => $password,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_data"',
  }

  icinga2::object::apply_service { 'rabbitmq partitions':
    import        => 'generic-service',
    check_command => 'rabbitmq-partitions',
    vars          => {
      'rabbitmq_partitions_username' => $username,
      'rabbitmq_partitions_password' => $password,
      'rabbitmq_partitions_node'     => 'host.name.split(".").get(0)'
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_data"',
  }

  icinga2::object::apply_service { 'rabbitmq server':
    import        => 'generic-service',
    check_command => 'rabbitmq-server',
    vars          => {
      'rabbitmq_server_username' => $username,
      'rabbitmq_server_password' => $password,
      'rabbitmq_server_node'     => 'host.name.split(".").get(0)',
      'rabbitmq_server_warning'  => 80,
      'rabbitmq_server_critical' => 90,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_data"',
  }

  icinga2::object::apply_service { 'rabbitmq watermark':
    import        => 'generic-service',
    check_command => 'rabbitmq-watermark',
    vars          => {
      'rabbitmq_watermark_username' => $username,
      'rabbitmq_watermark_password' => $password,
      'rabbitmq_watermark_node'     => 'host.name.split(".").get(0)'
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_data"',
  }

}
