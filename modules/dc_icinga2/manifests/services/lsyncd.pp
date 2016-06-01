# == Class: dc_icinga2::services::lsyncd
#
# Checks an lsyncd process is running
#
class dc_icinga2::services::lsyncd {

  icinga2::object::apply_service { 'lsyncd':
    import        => 'generic-service',
    check_command => 'procs',
    vars          => {
      'procs_critical' => '1:',
      'procs_argument' => 'lsyncd',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "puppet_ca" || host.vars.role == "dns_master"',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
