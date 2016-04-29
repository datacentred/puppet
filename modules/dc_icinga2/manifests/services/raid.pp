# == Class: dc_icinga2::services::raid
#
# Monitor RAID services
#
class dc_icinga2::services::raid {

  icinga2::object::apply_service { 'raid':
    import        => 'generic-service',
    check_command => 'raid',
    zone          => 'host.name',
    assign_where  => 'host.vars.operatingsystem',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
