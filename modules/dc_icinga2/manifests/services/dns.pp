# == Class: dc_icinga2::services::dns
#
# Monitor DNS services
#
class dc_icinga2::services::dns {

  icinga2::object::apply_service { 'dns':
    import        => 'generic-service',
    check_command => 'dns',
    vars          => {
      'enable_pagerduty' => true,
    },
    zone          => 'host.name',
    assign_where  => 'match("dns_*, host.vars.role)',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
