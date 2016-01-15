# == Class: dc_icinga2::services::dhcp
#
# By necessity DHCP checks are run passively from their parent
# zones (e.g. icinga2 domain master/satellite zone).  Ensures
# the requested server returns our DHCP record.
#
# === Notes
#
# Assumes icinga2 servers will only ever use a bonded interface
# on the services network where the DHCP server resides.
#
class dc_icinga2::services::dhcp {

  icinga2::object::apply_service { 'dhcp':
    import        => 'default-service',
    check_command => 'dhcp_sudo',
    vars          => {
      'dhcp_serverip'  => 'host.address',
      'dhcp_interface' => 'bond0',
      'dhcp_unicast'   => true,
    },
    assign_where  => 'match("dns_*", host.vars.role)',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
