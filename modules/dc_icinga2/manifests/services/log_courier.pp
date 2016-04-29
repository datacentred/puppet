# == Class: dc_icinga2::services::log_courier
#
# Checks log courier processes are running and sending logs
#
class dc_icinga2::services::log_courier {

  icinga2::object::apply_service { 'log courier':
    import        => 'generic-service',
    check_command => 'log-courier',
    vars          => {
      'log_courier_backlog_warning'  => 20,
      'log_courier_backlog_critical' => 50,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.operatingsystem',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
