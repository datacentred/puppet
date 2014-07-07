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

  # Gather our API endpoints
  $keystone_api_servers = get_exported_var('', 'keystone_host', ['localhost'])
  $glance_api_servers   = get_exported_var('', 'glance_api', ['localhost'])
  $neutron_api_servers  = get_exported_var('', 'neutron_api', ['localhost'])
  $nova_api_servers     = get_exported_var('', 'nova_api', ['localhost'])
  $cinder_api_servers   = get_exported_var('', 'cinder_api', ['localhost'])

  # Keystone
  haproxy::listen { 'keystone':
    ipaddress => '*',
    mode      => 'http',
    ports     => '5000',
    options   => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
    },
  }
  haproxy::balancermember { 'keystone':
    listening_service => 'keystone',
    server_names      => $keystone_api_servers,
    ipaddresses       => $keystone_api_servers,
    ports             => '5000',
    options           => 'check inter 2000 rise 2 fall 5',
  }
  haproxy::listen { 'keystone-auth':
    ipaddress => '*',
    mode      => 'http',
    ports     => '35357',
    options   => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
    },
  }
  haproxy::balancermember { 'keystone-auth':
    listening_service => 'keystone-auth',
    server_names      => $keystone_api_servers,
    ipaddresses       => $keystone_api_servers,
    ports             => '35357',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  # Glance
  haproxy::listen { 'glance-api':
    ipaddress => '*',
    mode      => 'http',
    ports     => '9292',
    options   => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
    },
  }
  haproxy::balancermember { 'glance-api':
    listening_service => 'glance-api',
    server_names      => $glance_api_servers,
    ipaddresses       => $glance_api_servers,
    ports             => '9292',
    options           => 'check inter 2000 rise 2 fall 5',
  }
  haproxy::listen { 'glance-reg':
    ipaddress => '*',
    mode      => 'http',
    ports     => '9191',
    options   => {
      'option'  => ['tcpka', 'tcplog'],
      'balance' => 'source',
    },
  }
  haproxy::balancermember { 'glance-reg':
    listening_service => 'glance-reg',
    server_names      => $glance_api_servers,
    ipaddresses       => $glance_api_servers,
    ports             => '9191',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  # Neutron
  haproxy::listen { 'neutron':
    ipaddress => '*',
    mode      => 'http',
    ports     => '9696',
    options   => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
    },
  }
  haproxy::balancermember { 'neutron':
    listening_service => 'neutron',
    server_names      => $neutron_api_servers,
    ipaddresses       => $neutron_api_servers,
    ports             => '9696',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  # Nova
  haproxy::listen { 'nova-compute':
    ipaddress => '*',
    mode      => 'http',
    ports     => '8774',
    options   => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
    },
  }
  haproxy::balancermember { 'nova-compute':
    listening_service => 'nova-compute',
    server_names      => $nova_api_servers,
    ipaddresses       => $nova_api_servers,
    ports             => '8774',
    options           => 'check inter 2000 rise 2 fall 5',
  }
  haproxy::listen { 'nova-metadata':
    ipaddress => '*',
    mode      => 'http',
    ports     => '8775',
    options   => $listeneroptions,
  }
  haproxy::balancermember { 'nova-metadata':
    listening_service => 'nova-metadata',
    server_names      => $nova_api_servers,
    ipaddresses       => $nova_api_servers,
    ports             => '8775',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  # Cinder
  haproxy::listen { 'cinder':
    ipaddress => '*',
    mode      => 'http',
    ports     => '8776',
    options   => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
    },
  }
  haproxy::balancermember { 'cinder':
    listening_service => 'cinder',
    server_names      => $cinder_api_servers,
    ipaddresses       => $cinder_api_servers,
    ports             => '8776',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  # Horizon
  haproxy::listen { 'horizon':
    ipaddress => '*',
    mode      => 'http',
    ports     => '80',
    options   => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
    },
  }
  haproxy::balancermember { 'horizon':
    listening_service => 'horizon',
    server_names      => 'controller0.sal01.datacentred.co.uk',
    ipaddresses       => 'controller0.sal01.datacentred.co.uk',
    ports             => '80',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  # HAProxy Statistics
  haproxy::listen { 'haproxy-stats':
    ipaddress => '*',
    mode      => 'http',
    ports     => '1936',
    options   => {
      'stats' => ['enable', 'uri /'],
    },
  }
}
