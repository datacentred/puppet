# == Class: dc_icinga2::services::interface
#
# Checks network interfaces
#
class dc_icinga2::services::interface {

  icinga2::object::apply_service_for { 'interface':
    key           => 'interface',
    value         => 'attributes',
    hash          => 'host.vars.foreman_interfaces',
    import        => 'generic-service',
    check_command => 'interface',
    display_name  => '"interface " + interface',
    vars          => {
      'interface_name'    => 'interface',
      'interface_address' => 'attributes.address',
      'interface_netmask' => 'attributes.netmask',
      'interface_macaddr' => 'attributes.mac',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.operatingsystem',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
