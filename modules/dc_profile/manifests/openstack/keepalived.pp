# Class: dc_profile::openstack::keepalived
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

class dc_profile::openstack::keepalived {

  include ::keepalived

  $vrhash = hiera(virtual_routers)

  # Allow Linux to bind to IPs which don't yet exist
  sysctl { 'net.ipv4.ip_nonlocal_bind':
    ensure => present,
    value  => '1',
  }

  keepalived::vrrp::instance { 'os_api_int':
    interface         => 'eth0',
    state             => 'SLAVE',
    priority          => '100',
    virtual_router_id => $vrhash['os_api_int']['id'],
    virtual_ipaddress => [ $vrhash['os_api_int']['vip'] ],
  }

  keepalived::vrrp::instance { 'compute_api_int':
    interface         => 'eth0',
    state             => 'SLAVE',
    priority          => '100',
    virtual_router_id => $vrhash['compute_api_int']['id'],
    virtual_ipaddress => [ $vrhash['compute_api_int']['vip'] ],
  }

  keepalived::vrrp::instance { 'os_api_ext':
    interface         => 'eth1',
    state             => 'SLAVE',
    priority          => '100',
    virtual_router_id => $vrhash['os_api_ext']['id'],
    virtual_ipaddress => [ $vrhash['os_api_ext']['vip'] ],
  }

  keepalived::vrrp::instance { 'compute_api_ext':
    interface         => 'eth1',
    state             => 'SLAVE',
    priority          => '100',
    virtual_router_id => $vrhash['compute_api_ext']['id'],
    virtual_ipaddress => [ $vrhash['compute_api_ext']['vip'] ],
  }

}
