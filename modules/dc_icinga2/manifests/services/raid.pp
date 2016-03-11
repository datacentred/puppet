# == Class: dc_icinga2::services::raid
#
# Monitor RAID services
#
class dc_icinga2::services::raid {

  icinga2::object::apply_service { 'md raid':
    import        => 'generic-service',
    check_command => 'md-raid',
    zone          => 'host.name',
    assign_where  => true,
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
