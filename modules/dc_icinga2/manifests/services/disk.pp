# == Class: dc_icinga2::services::disk
#
# Checks disk utilisation
#
class dc_icinga2::services::disk {

  icinga2::object::apply_service { 'disk':
    import        => 'generic-service',
    check_command => 'disk',
    vars          => {
      'enable_pagerduty' => true,
    },
    zone          => 'host.name',
    assign_where  => true,
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
