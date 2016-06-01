# == Class: dc_icinga2::services::icingaweb2
#
# Checks icingaweb2 is responding
#
class dc_icinga2::services::icingaweb2 {

  icinga2::object::apply_service { 'icingaweb2':
    import        => 'generic-service',
    check_command => 'http',
    vars          => {
      'enable_pagerduty' => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "monitoring_master"',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
