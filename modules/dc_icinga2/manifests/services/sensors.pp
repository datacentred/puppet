# == Class: dc_icinga2::services::sensors
#
# Checks any local sensors against vendor thresholds
#
class dc_icinga2::services::sensors {

  icinga2::object::apply_service { 'sensors':
    import        => 'generic-service',
    check_command => 'sensors',
    zone          => 'host.name',
    assign_where  => 'host.vars.operatingsystem',
    ignore_where  => 'host.vars.is_virtual || host.vars.productname == "OpenStack Nova"',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
