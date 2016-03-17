# == Class: dc_icinga2::services::tftp
#
# Monitor TFTP services
#
class dc_icinga2::services::tftp {

  icinga2::object::apply_service { 'tftp':
    import        => 'generic-service',
    check_command => 'tftp',
    vars          => {
      'tftp_url' => 'pxelinux.0',
    },
    zone          => 'host.name',
    assign_where  => 'match("dns_*", host.vars.role)',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
