# == Class: dc_icinga2::services::generic
#
# Install generic service checks
#
class dc_icinga2::services::generic {

  tag $::fqdn, $::domain

  @@icinga2::object::service { "${::fqdn} ssh":
    check_name    => 'ssh',
    import        => 'generic-service',
    check_command => 'ssh',
  }

  @@icinga2::object::service { "${::fqdn} disk":
    check_name    => 'disk',
    import        => 'generic-service',
    check_command => 'disk',
    vars          => {
      'enable_pagerduty' => true,
    },
  }

  @@icinga2::object::service { "${::fqdn} load":
    check_name    => 'load',
    import        => 'generic-service',
    check_command => 'load',
  }

  @@icinga2::object::service { "${::fqdn} procs":
    check_name    => 'procs',
    import        => 'generic-service',
    check_command => 'procs',
  }

  @@icinga2::object::service { "${::fqdn} users":
    check_name    => 'users',
    import        => 'generic-service',
    check_command => 'users',
  }

  @@icinga2::object::service { "${::fqdn} memory":
    check_name    => 'memory',
    import        => 'generic-service',
    check_command => 'memory',
    vars          => {
      'enable_pagerduty' => true,
    },
  }

}
