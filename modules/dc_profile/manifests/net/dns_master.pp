# Class: dc_profile::net::dns_master
#
# DNS master node
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::net::dns_master {

  include ::dc_dns
  include ::dc_dns::static
  include ::dc_icinga::hostgroup_dns

}
