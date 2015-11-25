# == Class: dc_icinga2::services::memory
#
# Checks for memory starvation
#
class dc_icinga2::services::memory {

  icinga2::object::apply_service { 'memory':
    import        => 'generic-service',
    check_command => 'memory',
    zone          => 'host.name',
    assign_where  => true,
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
