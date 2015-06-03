# Class: dc_profile::net::dhcpd_master
#
# DHCP master node
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::net::dhcpd_master {

  include ::dhcp
  include ::dhcp::ddns
  include ::dhcp::failover
  include ::dc_dhcp::primary

}
