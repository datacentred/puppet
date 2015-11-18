# == Class: dc_icinga2::services::load
#
# Checks server load average
#
class dc_icinga2::services::load {

  icinga2::object::service { 'load':
    import        => 'generic-service',
    check_command => 'load',
    zone          => 'host.name',
    assign_where  => 'host.name',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
