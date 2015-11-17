# == Class: dc_icinga2::services::disk
#
# Checks disk utilisation
#
class dc_icinga2::services::disk {

  icinga2::object::service { 'disk':
    import        => 'generic-service',
    check_command => 'disk',
    vars          => {
      'enable_pagerduty' => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.name',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
