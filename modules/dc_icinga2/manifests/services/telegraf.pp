# == Class: dc_icinga2::services::telegraf
#
# Checks the telegraf process is running
#
class dc_icinga2::services::telegraf {

  icinga2::object::apply_service { 'telegraf':
    import        => 'generic-service',
    check_command => 'procs',
    vars          => {
      'procs_warning'  => '1',
      'procs_critical' => '1:',
      'procs_argument' => 'telegraf',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.operatingsystem',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
