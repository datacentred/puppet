# == Class: icinga2::services::mtu
#
# Checks MTU configurations
#
class dc_icinga2::services::mtu {

  icinga2::object::apply_service_for { 'mtu':
    key           => 'interface',
    value         => 'attributes',
    hash          => 'host.vars.interfaces',
    import        => 'generic-service',
    check_command => 'mtu',
    display_name  => '"mtu " + interface',
    vars          => {
      'mtu_interface' => 'interface',
      'mtu_mtu'       => 9000,
    },
    zone          => 'host.name',
    assign_where  => 'cidr_match("10.0.0.0/8", attributes.address)',
    ignore_where  => 'cidr_match("10.254.0.0/16", attributes.address) || host.vars.is_virtual',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
