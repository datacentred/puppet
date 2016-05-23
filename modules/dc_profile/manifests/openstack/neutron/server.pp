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

  case $::operatingsystem {
    'Ubuntu': {
      $packages = ['python-neutron-vpnaas', 'python-neutron-lbaas']
      $pydir = 'dist-packages'
    }
    'RedHat', 'CentOS': {
      $packages = ['openstack-neutron-fwaas', 'openstack-neutron-lbaas', 'openstack-neutron-vpnaas']
      $pydir = 'site-packages'
    }
    default: {}
  }

  # TODO: Remove post-upgrade
  file_line { 'neutron_auth_version':
    ensure  => absent,
    path    => '/etc/neutron/neutron.conf',
    line    => 'auth_version=V2.0',
    notify  => Service['neutron-server'],
    require => Package[$packages],
  }

  # Workaround for upstream packaging bugs and missing dependancies, such as:
  # https://bugs.launchpad.net/ubuntu/+source/neutron-lbaas/+bug/1460228
  ensure_packages($packages)

  file { '/etc/neutron/neutron_lbaas.conf':
    mode    => '0644',
    owner   => 'neutron',
    content => "[service_providers]\nservice_provider=LOADBALANCER:Haproxy:neutron_lbaas.services.loadbalancer.drivers.haproxy.plugin_driver.HaproxyOnHostPluginDriver:default",
    require => Package[$packages],
  }

  file { '/etc/neutron/neutron_vpnaas.conf':
    mode    => '0644',
    owner   => 'neutron',
    content => "[service_providers]\nservice_provider=VPN:openswan:neutron_vpnaas.services.vpn.service_drivers.ipsec.IPsecVPNDriver:default",
    require => Package[$packages],
  }

  # TODO: Remove once we've upgraded to Liberty
  # This patch enables migration of legacy routers to L3-HA via router-update
  # See https://bugs.launchpad.net/neutron/+bug/1365426
  file {"/usr/lib/python2.7/${pydir}/neutron/db/l3_hamode_db.py":
    mode    => '0644',
    owner   => 'neutron',
    group   => 'neutron',
    source  => 'puppet:///modules/dc_openstack/l3_hamode_db.py',
    notify  => Service['neutron-server'],
    require => Package[$packages],
  }

  # TODO: Remove once we've upgraded to Liberty
  # As above
  file {"/usr/lib/python2.7/${pydir}/neutron/extensions/l3_ext_ha_mode.py":
    mode    => '0644',
    owner   => 'neutron',
    group   => 'neutron',
    source  => 'puppet:///modules/dc_openstack/l3_ext_ha_mode.py',
    notify  => Service['neutron-server'],
    require => Package[$packages],
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
