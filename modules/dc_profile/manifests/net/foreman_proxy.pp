# Class: dc_profile::net::foreman_proxy
#
# Foreman proxy for network services: DNS, DHCP & TFTP
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::net::foreman_proxy {

  include ::dc_foreman_proxy
  include ::dc_foreman::service_checks
  include ::dc_icinga::hostgroup_foreman_proxy

}
