# == Class: dc_icinga2::services::pdu
#
# Passive SNMP monitoring for PDUs
#
class dc_icinga2::services::pdu {

  Icinga2::Object::Apply_services {
    target => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

  icinga2::object::apply_service { 'pdu dns':
    import        => 'generic-service',
    check_command => 'dns',
    assign_where  => 'host.vars.role == "apc-pdu"',
  }

  icinga2::object::apply_service { 'pdu temperature':
    import        => 'generic-service',
    check_command => 'snmp',
    vars          => {
      snmp_oid => '.1.3.6.1.4.1.318.1.1.26.10.2.2.1.8.1',
    },
    assign_where  => 'host.vars.role == "apc-pdu" && host.vars.environmental_monitoring',
  }

  icinga2::object::apply_service { 'pdu humidity':
    import        => 'generic-service',
    check_command => 'snmp',
    vars          => {
      snmp_oid => '.1.3.6.1.4.1.318.1.1.26.10.2.2.1.10.1',
    },
    assign_where  => 'host.vars.role == "apc-pdu" && host.vars.environmental_monitoring',
  }

}
