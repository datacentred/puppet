# Class: dc_profile::net::keepalived
#
# Configures keepalived
#
# Parameters:
#
# Actions:
#
# Requires: puppet-keepalived
#
# Sample Usage:
#
class dc_profile::net::keepalived (
  $keepalived_hash,
) {

  include ::keepalived

  keepalived::vrrp::instance { "keepalived_${::hostname}" :
    interface          => $keepalived_hash['interface'],
    state              => 'SLAVE',
    priority           => '100',
    virtual_router_id  => $keepalived_hash['virtual_router_id'],
    virtual_ipaddress  => $keepalived_hash['virtual_ipaddress'],
  }
}
