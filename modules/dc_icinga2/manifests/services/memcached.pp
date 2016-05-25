# == Class: dc_icinga2::services::memcached
#
# Checks the availabilty of memcached instances
#
class dc_icinga2::services::memcached {

  icinga2::object::apply_service { 'memcached':
    import        => 'generic-service',
    check_command => 'memcached',
    vars          => {
      'memcached_rate_per_minute' => true,
      'enable_pagerduty'          => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_data"',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
