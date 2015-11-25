# == Class: dc_icinga2::services::load
#
# Checks server load average
#
class dc_icinga2::services::load {

  icinga2::object::apply_service { 'load':
    import        => 'generic-service',
    check_command => 'load',
    vars          => {
      'load_percpu' => true,
    },
    zone          => 'host.name',
    assign_where  => true,
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
