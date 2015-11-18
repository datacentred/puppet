# == Class: dc_icinga2::services::procs
#
# Checks the nuber of processes running
#
class dc_icinga2::services::procs {

  icinga2::object::service { 'procs':
    import        => 'generic-service',
    check_command => 'procs',
    zone          => 'host.name',
    assign_where  => 'host.name',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
