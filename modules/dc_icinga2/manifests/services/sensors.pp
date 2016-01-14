# == Class: dc_icinga2::services::sensors
#
# Checks any local sensors against vendor thresholds
#
class dc_icinga2::services::sensors {

  icinga2::object::apply_service { 'sensors':
    import        => 'generic-service',
    check_command => 'sensors',
    zone          => 'host.name',
    assign_where  => true,
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
