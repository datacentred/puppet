# == Class: dc_icinga2::services::procs
#
# Checks the nuber of processes running
#
class dc_icinga2::services::procs {

  icinga2::object::apply_service { 'procs':
    import        => 'generic-service',
    check_command => 'procs',
    vars          => {
      'procs_nokthreads' => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.name',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
