# Class: dc_dhcpdpools
#
class dc_dhcpdpools {

  create_resources('dhcp::pool', hiera_hash(dhcp_pools))

}
