# Class: dc_profile::openstack::haproxy
#
# Configures HAproxy with SSL support
# for the various OpenStack API endpoints
#
# Parameters:
#
# Actions:
#
# Requires: datacentred-haproxy, dev version of haproxy that
#           includes SSL support
#
# Sample Usage:
#
# TODO: Enable SSL endpoints once we've stood up the necessary
# infrastructure

class dc_profile::openstack::haproxy {

  include ::haproxy

  # Filesystem location of the SSL certificate

  # Default haproxy options applicable to all listeners
  $listeneroptions =  {
                        'option'  => ['tcpka', 'httpchk', 'tcplog'],
                        'balance' => 'source',
                      }

  # Default haproxy options applicable to all balancermembers
  $balanceroptions = 'check inter 2000 rise 2 fall 5'

  # Gather our API endpoints
  $keystone_api_servers = get_exported_var('', 'keystone_host', ['localhost'])
  $glance_api_servers   = get_exported_var('', 'glance_api', ['localhost'])
  $neutron_api_servers  = get_exported_var('', 'neutron_api', ['localhost'])
  $nova_api_servers     = get_exported_var('', 'nova_api', ['localhost'])
  $cinder_api_servers   = get_exported_var('', 'cinder_api', ['localhost'])

  # Keystone
  haproxy::listen { 'keystone':
    ipaddress => '*',
    ports     => '5000',
    options   => $listeneroptions,
  }
  haproxy::balancermember { 'keystone':
    listening_service => 'keystone',
    server_names      => $keystone_api_servers,
    ipaddresses       => $keystone_api_servers,
    ports             => '5000',
    options           => $balanceroptions,
  }

  # Glance
  haproxy::listen { 'glance-api':
    ipaddress => '*',
    ports     => '9292',
    options   => $listeneroptions,
  }
  haproxy::balancermember { 'glance-api':
    listening_service => 'glance-api',
    server_names      => $glance_api_servers,
    ipaddresses       => $glance_api_servers,
    ports             => '9292',
    options           => $balanceroptions,
  }
  haproxy::listen { 'glance-reg':
    ipaddress => '*',
    ports     => '9191',
    options   => $listeneroptions,
  }
  haproxy::balancermember { 'glance-reg':
    listening_service => 'glance-reg',
    server_names      => $glance_api_servers,
    ipaddresses       => $glance_api_servers,
    ports             => '9191',
    options           => $balanceroptions,
  }

  # Neutron
  haproxy::listen { 'neutron':
    ipaddress => '*',
    ports     => '9696',
    options   => $listeneroptions,
  }
  haproxy::balancermember { 'neutron':
    listening_service => 'neutron',
    server_names      => $neutron_api_servers,
    ipaddresses       => $neutron_api_servers,
    ports             => '9696',
    options           => $balanceroptions,
  }

  # Nova
  haproxy::listen { 'nova-compute':
    ipaddress => '*',
    ports     => '8774',
    options   => $listeneroptions,
  }
  haproxy::balancermember { 'nova-compute':
    listening_service => 'nova-compute',
    server_names      => $nova_api_servers,
    ipaddresses       => $nova_api_servers,
    ports             => '8774',
    options           => $balanceroptions,
  }
  haproxy::listen { 'nova-metadata':
    ipaddress => '*',
    ports     => '8775',
    options   => $listeneroptions,
  }
  haproxy::balancermember { 'nova-metadata':
    listening_service => 'nova-metadata',
    server_names      => $nova_api_servers,
    ipaddresses       => $nova_api_servers,
    ports             => '8775',
    options           => $balanceroptions,
  }

  # Cinder
  haproxy::listen { 'cinder':
    ipaddress => '*',
    ports     => '8776',
    options   => $listeneroptions,
  }
  haproxy::balancermember { 'cinder':
    listening_service => 'cinder',
    server_names      => $cinder_api_servers,
    ipaddresses       => $cinder_api_servers,
    ports             => '8776',
    options           => $balanceroptions,
  }

  # Horizon
  haproxy::listen { 'horizon':
    ipaddress => '*',
    ports     => '80',
    options   => $listeneroptions,
  }
  haproxy::balancermember { 'horizon':
    listening_service => 'horizon',
    server_names      => 'controller0.sal01.datacentred.co.uk',
    ipaddresses       => 'controller0.sal01.datacentred.co.uk',
    ports             => '80',
    options           => $balanceroptions,
  }
}
