# == Class: dc_icinga2::services::mongodb
#
# Checks MongoDB is healthy
#
class dc_icinga2::services::mongodb (
  $username = 'username',
  $password = 'password',
) {

  Icinga2::Object::Apply_service {
    target => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

  icinga2::object::apply_service { 'mongodb connect':
    import        => 'generic-service',
    check_command => 'dc_mongodb',
    vars          => {
      'mongodb_username' => $username,
      'mongodb_password' => $password,
      'mongodb_action'   => 'connect',
      'mongodb_warning'  => 2,
      'mongodb_critical' => 4,
      'enable_pagerduty' => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_mongodb"',
  }

  icinga2::object::apply_service { 'mongodb connections':
    import        => 'generic-service',
    check_command => 'dc_mongodb',
    vars          => {
      'mongodb_username' => $username,
      'mongodb_password' => $password,
      'mongodb_action'   => 'connections',
      'mongodb_warning'  => 70,
      'mongodb_critical' => 80,
      'enable_pagerduty' => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_mongodb"',
  }

  icinga2::object::apply_service { 'mongodb replication lag':
    import        => 'generic-service',
    check_command => 'dc_mongodb',
    vars          => {
      'mongodb_host'     => 'host.name',
      'mongodb_username' => $username,
      'mongodb_password' => $password,
      'mongodb_action'   => 'replication_lag',
      'mongodb_warning'  => 15,
      'mongodb_critical' => 30,
      'enable_pagerduty' => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_mongodb"',
  }

  icinga2::object::apply_service { 'mongodb replication lag percent':
    import        => 'generic-service',
    check_command => 'dc_mongodb',
    vars          => {
      'mongodb_host'     => 'host.name',
      'mongodb_username' => $username,
      'mongodb_password' => $password,
      'mongodb_action'   => 'replication_lag_percent',
      'mongodb_warning'  => 50,
      'mongodb_critical' => 75,
      'enable_pagerduty' => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_mongodb"',
  }

  icinga2::object::apply_service { 'mongodb memory':
    import        => 'generic-service',
    check_command => 'dc_mongodb',
    vars          => {
      'mongodb_username' => $username,
      'mongodb_password' => $password,
      'mongodb_action'   => 'memory',
      'enable_pagerduty' => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_mongodb"',
  }

  icinga2::object::apply_service { 'mongodb lock time percentage':
    import        => 'generic-service',
    check_command => 'dc_mongodb',
    vars          => {
      'mongodb_username' => $username,
      'mongodb_password' => $password,
      'mongodb_action'   => 'lock',
      'mongodb_warning'  => 5,
      'mongodb_critical' => 10,
      'enable_pagerduty' => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_mongodb"',
  }

  icinga2::object::apply_service { 'mongodb flush average':
    import        => 'generic-service',
    check_command => 'dc_mongodb',
    vars          => {
      'mongodb_username' => $username,
      'mongodb_password' => $password,
      'mongodb_action'   => 'flushing',
      'mongodb_warning'  => 30000,
      'mongodb_critical' => 50000,
      'enable_pagerduty' => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_mongodb"',
  }

  icinga2::object::apply_service { 'mongodb last flush':
    import        => 'generic-service',
    check_command => 'dc_mongodb',
    vars          => {
      'mongodb_username' => $username,
      'mongodb_password' => $password,
      'mongodb_action'   => 'last_flush_time',
      'mongodb_warning'  => 30000,
      'mongodb_critical' => 50000,
      'enable_pagerduty' => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_mongodb"',
  }

  icinga2::object::apply_service { 'mongodb replica state':
    import        => 'generic-service',
    check_command => 'dc_mongodb',
    vars          => {
      'mongodb_username' => $username,
      'mongodb_password' => $password,
      'mongodb_action'   => 'replset_state',
      'mongodb_warning'  => 0,
      'mongodb_critical' => 0,
      'enable_pagerduty' => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_mongodb"',
  }

  icinga2::object::apply_service { 'mongodb index miss':
    import        => 'generic-service',
    check_command => 'dc_mongodb',
    vars          => {
      'mongodb_username' => $username,
      'mongodb_password' => $password,
      'mongodb_action'   => 'index_miss_ratio',
      'mongodb_warning'  => 0.005,
      'mongodb_critical' => 0.010,
      'enable_pagerduty' => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_mongodb"',
  }

  icinga2::object::apply_service { 'mongodb primary connection':
    import        => 'generic-service',
    check_command => 'dc_mongodb',
    vars          => {
      'mongodb_username' => $username,
      'mongodb_password' => $password,
      'mongodb_action'   => 'connect_primary',
      'mongodb_warning'  => 2,
      'mongodb_critical' => 4,
      'enable_pagerduty' => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_mongodb"',
  }

}
