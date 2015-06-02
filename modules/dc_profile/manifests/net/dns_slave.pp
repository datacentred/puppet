# Class: dc_profile::net::dns_slave
#
# DNS slave node
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::net::dns_slave {

  include ::dc_dns
  include ::dc_icinga::hostgroup_dns

}
