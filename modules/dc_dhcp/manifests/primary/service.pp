# == Class: dc_dhcp::primary::service
#
# Ensure the dhcp synchronisation agent service is running
#
class dc_dhcp::primary::service {

  assert_private()

  service { 'dhcp_sync_agent':
    ensure => running,
  }

}
