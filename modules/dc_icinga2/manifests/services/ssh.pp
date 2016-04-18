# == Class: dc_icinga2::services::ssh
#
# Check SSH daemon is running
#
class dc_icinga2::services::ssh {

  icinga2::object::apply_service { 'ssh':
    import        => 'generic-service',
    check_command => 'ssh',
    zone          => 'host.name',
    assign_where  => 'host.vars.os',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
