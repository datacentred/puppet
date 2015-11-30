# Class: dc_profile::openstack::neutron::server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::neutron::server {

  include ::neutron
  include ::neutron::keystone::auth
  include ::neutron::server
  include ::neutron::server::notifications
  include ::neutron::plugins::ml2
  include ::neutron::quota
  include ::dc_icinga::hostgroup_neutron_server

  # Workaround for upstream packaging bugs, such as:
  # https://bugs.launchpad.net/ubuntu/+source/neutron-lbaas/+bug/1460228
  ensure_packages( ['python-neutron-vpnaas', 'python-neutron-lbaas'] )

  file { '/etc/neutron/neutron_lbaas.conf':
    mode    => '0644',
    owner   => 'neutron',
    content => "[service_providers]\nservice_provider=LOADBALANCER:Haproxy:neutron_lbaas.services.loadbalancer.drivers.haproxy.plugin_driver.HaproxyOnHostPluginDriver:default",
    require => Package['python-neutron-lbaas'],
  }

  file { '/etc/neutron/neutron_vpnaas.conf':
    mode    => '0644',
    owner   => 'neutron',
    content => "[service_providers]\nservice_provider=VPN:openswan:neutron_vpnaas.services.vpn.service_drivers.ipsec.IPsecVPNDriver:default",
    require => Package['python-neutron-vpnaas'],
  }

  # Add this node's API services into our loadbalancer
  @@haproxy::balancermember { "${::fqdn}-neutron":
    listening_service => 'neutron',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress,
    ports             => '9696',
    options           => 'check inter 2000 rise 2 fall 5',
  }

}
