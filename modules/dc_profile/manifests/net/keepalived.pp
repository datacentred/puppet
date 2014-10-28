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

  # Allow Linux to bind to IPs which don't yet exist
  sysctl { 'net.ipv4.ip_nonlocal_bind':
    ensure    => present,
    value     => '1',
  }

  keepalived::vrrp::instance { "keepalived_${::hostname}" :
    interface          => $keepalived_hash['interface'],
    state              => 'SLAVE',
    priority           => '100',
    virtual_router_id  => $keepalived_hash['virtual_router_id'],
    virtual_ipaddress  => $keepalived_hash['virtual_ipaddress'],
  }
}
