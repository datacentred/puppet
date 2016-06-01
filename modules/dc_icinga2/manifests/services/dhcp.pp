# == Class: dc_icinga2::services::dhcp
#
# By necessity DHCP checks are run passively from their parent
# zones (e.g. icinga2 domain master/satellite zone).  Ensures
# the requested server returns our DHCP record.
#
class dc_icinga2::services::dhcp {

  icinga2::object::apply_service_for { 'dhcp':
    key           => 'interface',
    value         => 'attributes',
    hash          => 'host.vars.interfaces',
    import        => 'generic-service',
    check_command => 'dhcp_sudo',
    display_name  => '"dhcp " + interface',
    vars          => {
      'dhcp_serverip'    => 'host.address',
      'dhcp_interface'   => 'interface',
      'dhcp_unicast'     => true,
      'enable_pagerduty' => true,
    },
    assign_where  => 'match("dns_*", host.vars.role) && host.address == attributes.address',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
