# == Class: dc_icinga2::services::dhcp
#
# By necessity DHCP checks are run passively from their parent
# zones (e.g. icinga2 domain master/satellite zone).  Ensures
# the requested server returns our DHCP record.
#
class dc_icinga2::services::dhcp {

  icinga2::object::apply_service { 'dhcp':
    import        => 'generic-service',
    check_command => 'dhcp_sudo',
    vars          => {
      'dhcp_serverip'    => 'host.address',
      'dhcp_interface'   => 'get_host(NodeName).vars.primary_interface',
      'dhcp_unicast'     => true,
      'enable_pagerduty' => true,
    },
    assign_where  => 'match("dns_*", host.vars.role)',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
