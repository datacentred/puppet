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

  # Set in Foreman per-host
  $priority = $::vrpriority

  keepalived::vrrp::instance { 'os_api_int':
      interface          => 'eth0',
      state              => 'MASTER',
      priority           => $priority,
      virtual_router_id  => $vrhash['os_api_int']['id'],
      virtual_ipaddress  => [ $vrhash['os_api_int']['vip'] ],
  }

  keepalived::vrrp::instance { 'os_api_ext':
      interface          => 'eth1',
      state              => 'MASTER',
      priority           => $priority,
      virtual_router_id  => $vrhash['os_api_ext']['id'],
      virtual_ipaddress  => [ $vrhash['os_api_ext']['vip'] ],
  }

}
