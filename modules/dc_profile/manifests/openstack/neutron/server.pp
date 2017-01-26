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
  include ::neutron::server
  include ::neutron::server::notifications
  include ::neutron::plugins::ml2
  include ::neutron::quota
  include ::dc_icinga::hostgroup_neutron_server

  # Workaround for upstream packaging bugs and missing dependancies, such as:
  # https://bugs.launchpad.net/ubuntu/+source/neutron-lbaas/+bug/1460228
  ensure_packages(['python-neutron-vpnaas', 'python-neutron-lbaas'])

  neutron_config {
    'DEFAULT/allow_automatic_dhcp_failover': value => false;
    'DEFAULT/enable_services_on_agents_with_admin_state_down': value => true;
  }

  # TODO: Remove post-upgrade
  file_line { 'neutron_auth_version':
    ensure  => absent,
    path    => '/etc/neutron/neutron.conf',
    line    => 'auth_version=V2.0',
    notify  => Service['neutron-server'],
    require => Package['python-neutron-vpnaas'],
  }

  file { '/etc/neutron/neutron_lbaas.conf':
    mode    => '0644',
    owner   => 'neutron',
    content => "[service_providers]\nservice_provider=LOADBALANCER:Haproxy:neutron_lbaas.services.loadbalancer.drivers.haproxy.plugin_driver.HaproxyOnHostPluginDriver:default",
    require => Package['python-neutron-vpnaas'],
  }

  file { '/etc/neutron/neutron_vpnaas.conf':
    mode    => '0644',
    owner   => 'neutron',
    content => "[service_providers]\nservice_provider=VPN:openswan:neutron_vpnaas.services.vpn.service_drivers.ipsec.IPsecVPNDriver:default",
    require => Package['python-neutron-vpnaas'],
  }

}
