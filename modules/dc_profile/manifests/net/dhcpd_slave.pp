# Class: dc_profile::net::dhcpd_slave
#
# DHCP slave node
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::net::dhcpd_slave {

  include ::dhcp
  include ::dhcp::ddns
  include ::dhcp::failover
  include ::dc_dhcp::secondary
  include ::dc_icinga::hostgroup_dhcp
  include ::dc_apparmor::dhcpd
}
