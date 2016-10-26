# == Class: dc_icinga2::services::ntp
#
# Ensures NTP is in synchronization with an upstream server (e.g. working)
#
class dc_icinga2::services::ntp {

  icinga2::object::apply_service { 'ntp time':
    import        => 'generic-service',
    check_command => 'ntp_time',
    vars          => {
      'ntp_address'  => "ntp0.${::domain}",
      'ntp_warning'  => 0.1,
      'ntp_critical' => 0.5,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.operatingsystem',
    ignore_where  => 'host.vars.is_virtual || host.vars.productname == "OpenStack Nova"',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
