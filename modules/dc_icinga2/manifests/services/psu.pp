# == Class: dc_icinga2::services::psu
#
# Monitor PSU status on platforms that support it
#
class dc_icinga2::services::psu {

  Icinga2::Object::Apply_service {
    target => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

  icinga2::object::apply_service { 'psu X8DTT-H':
    import        => 'generic-service',
    check_command => 'psu',
    vars          => {
      'psu_a_raw' => '0x06 0x52 0x07 0x78 0x01 0x78',
      'psu_b_raw' => '0x06 0x52 0x07 0x7a 0x01 0x78',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.productname == "X8DTT-H"',
  }

  icinga2::object::apply_service { 'psu X9DRT':
    import        => 'generic-service',
    check_command => 'psu',
    vars          => {
      'psu_a_raw' => '0x06 0x52 0x07 0x70 0x01 0x0c',
      'psu_b_raw' => '0x06 0x52 0x07 0x72 0x01 0x0c',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.productname == "X9DRT"',
  }

}
