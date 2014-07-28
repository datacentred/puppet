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
  include ::dc_ssl::haproxy

  # Gather our API endpoints
  $horizon_servers       = get_exported_var('', 'horizon_host', ['localhost'])
  $keystone_api_servers  = get_exported_var('', 'keystone_host', ['localhost'])
  $glance_api_servers    = get_exported_var('', 'glance_api', ['localhost'])
  $neutron_api_servers   = get_exported_var('', 'neutron_api', ['localhost'])
  $nova_api_servers      = get_exported_var('', 'nova_api', ['localhost'])
  $cinder_api_servers    = get_exported_var('', 'cinder_api', ['localhost'])

  # Gather our IP Addresses
  $internal_bind_servers = [$::ipaddress_eth0, get_ip_addr("osapi.${domain}")]
  $external_bind_servers = [$::ipaddress_eth1, get_ip_addr('openstack.datacentred.io')]

  # Allow Linux to bind to IPs which don't yet exist
  sysctl { 'net.ipv4.ip_nonlocal_bind':
    ensure    => present,
    value     => '1',
  }

  # Redirect all horizon requests to SSL
  haproxy::listen { 'http-to-https-redirect':
    ipaddress => '*',
    mode      => 'http',
    ports     => '80',
    options   => {
      'redirect' => 'scheme https if !{ ssl_fc }',
    }
  }

  ##
  # Internal Services
  ##

  # HAProxy Statistics
  haproxy::listen { 'haproxy-stats':
    ipaddress    => $internal_bind_servers,
    mode         => 'http',
    ports        => '1936',
    bind_options => [
      'ssl',
      'crt /etc/ssl/certs/osapi_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'stats'  => ['enable', 'uri /'],
      'rspadd' => 'Strict-Transport-Security:\ max-age=60',
    },
  }

  # Keystone Auth
  haproxy::listen { 'keystone-auth-internal':
    ipaddress    => $internal_bind_servers,
    mode         => 'http',
    ports        => '5000',
    bind_options => [
      'ssl',
      'crt /etc/ssl/certs/osapi_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }
  haproxy::balancermember { 'keystone-auth-internal':
    listening_service => 'keystone-auth-internal',
    server_names      => $keystone_api_servers,
    ipaddresses       => $keystone_api_servers,
    ports             => '5000',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  # Keystone Admin
  haproxy::listen { 'keystone-admin-internal':
    ipaddress    => $internal_bind_servers,
    mode         => 'http',
    ports        => '35357',
    bind_options => [
      'ssl',
      'crt /etc/ssl/certs/osapi_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }
  haproxy::balancermember { 'keystone-admin-internal':
    listening_service => 'keystone-admin-internal',
    server_names      => $keystone_api_servers,
    ipaddresses       => $keystone_api_servers,
    ports             => '35357',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  # Glance API
  haproxy::listen { 'glance-api-internal':
    ipaddress    => $internal_bind_servers,
    mode         => 'http',
    ports        => '9292',
    bind_options => [
      'ssl',
      'crt /etc/ssl/certs/osapi_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'   => ['tcpka', 'httpchk', 'tcplog'],
      'balance'  => 'source',
      'rspadd'   => 'Strict-Transport-Security:\ max-age=60',
    },
  }
  haproxy::balancermember { 'glance-api-internal':
    listening_service => 'glance-api-internal',
    server_names      => $glance_api_servers,
    ipaddresses       => $glance_api_servers,
    ports             => '9292',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  # Glance Registry
  haproxy::listen { 'glance-registry-internal':
    ipaddress    => $internal_bind_servers,
    mode         => 'http',
    ports        => '9191',
    bind_options => [
      'ssl',
      'crt /etc/ssl/certs/osapi_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }
  haproxy::balancermember { 'glance-registry-internal':
    listening_service => 'glance-registry-internal',
    server_names      => $glance_api_servers,
    ipaddresses       => $glance_api_servers,
    ports             => '9191',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  # Neutron
  haproxy::listen { 'neutron-internal':
    ipaddress    => $internal_bind_servers,
    mode         => 'http',
    ports        => '9696',
    bind_options => [
      'ssl',
      'crt /etc/ssl/certs/osapi_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }
  haproxy::balancermember { 'neutron-internal':
    listening_service => 'neutron-internal',
    server_names      => $neutron_api_servers,
    ipaddresses       => $neutron_api_servers,
    ports             => '9696',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  # Nova Compute
  haproxy::listen { 'nova-compute-internal':
    ipaddress    => $internal_bind_servers,
    mode         => 'http',
    ports        => '8774',
    bind_options => [
      'ssl',
      'crt /etc/ssl/certs/osapi_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }
  haproxy::balancermember { 'nova-compute-internal':
    listening_service => 'nova-compute-internal',
    server_names      => $nova_api_servers,
    ipaddresses       => $nova_api_servers,
    ports             => '8774',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  # Nova Metadata
  haproxy::listen { 'nova-metadata-internal':
    ipaddress    => $internal_bind_servers,
    mode         => 'http',
    ports        => '8775',
    bind_options => [
      'ssl',
      'crt /etc/ssl/certs/osapi_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }
  haproxy::balancermember { 'nova-metadata-internal':
    listening_service => 'nova-metadata-internal',
    server_names      => $nova_api_servers,
    ipaddresses       => $nova_api_servers,
    ports             => '8775',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  # Cinder
  haproxy::listen { 'cinder-internal':
    ipaddress    => $internal_bind_servers,
    mode         => 'http',
    ports        => '8776',
    bind_options => [
      'ssl',
      'crt /etc/ssl/certs/osapi_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }
  haproxy::balancermember { 'cinder-internal':
    listening_service => 'cinder-internal',
    server_names      => $cinder_api_servers,
    ipaddresses       => $cinder_api_servers,
    ports             => '8776',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  # Horizon
  haproxy::listen { 'horizon-internal':
    ipaddress    => $internal_bind_servers,
    mode         => 'http',
    ports        => '443',
    bind_options => [
      'ssl',
      'crt /etc/ssl/certs/osapi_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }
  haproxy::balancermember { 'horizon-internal':
    listening_service => 'horizon-internal',
    server_names      => $horizon_servers,
    ipaddresses       => $horizon_servers,
    ports             => '80',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  ##
  # External Services
  ##

  # Keystone Auth
  haproxy::listen { 'keystone-auth-external':
    ipaddress    => $external_bind_servers,
    mode         => 'http',
    ports        => '5000',
    bind_options => [
      'ssl',
      'crt /etc/ssl/certs/openstack_datacentred_io.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }
  haproxy::balancermember { 'keystone-auth-external':
    listening_service => 'keystone-auth-external',
    server_names      => $keystone_api_servers,
    ipaddresses       => $keystone_api_servers,
    ports             => '5000',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  # Glance API
  haproxy::listen { 'glance-api-external':
    ipaddress    => $external_bind_servers,
    mode         => 'http',
    ports        => '9292',
    bind_options => [
      'ssl',
      'crt /etc/ssl/certs/openstack_datacentred_io.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'   => ['tcpka', 'httpchk', 'tcplog'],
      'balance'  => 'source',
      'rspadd'   => 'Strict-Transport-Security:\ max-age=60',
    },
  }
  haproxy::balancermember { 'glance-api-external':
    listening_service => 'glance-api-external',
    server_names      => $glance_api_servers,
    ipaddresses       => $glance_api_servers,
    ports             => '9292',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  # Neutron
  haproxy::listen { 'neutron-external':
    ipaddress    => $external_bind_servers,
    mode         => 'http',
    ports        => '9696',
    bind_options => [
      'ssl',
      'crt /etc/ssl/certs/openstack_datacentred_io.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }
  haproxy::balancermember { 'neutron-external':
    listening_service => 'neutron-external',
    server_names      => $neutron_api_servers,
    ipaddresses       => $neutron_api_servers,
    ports             => '9696',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  # Nova Compute
  haproxy::listen { 'nova-compute-external':
    ipaddress    => $external_bind_servers,
    mode         => 'http',
    ports        => '8774',
    bind_options => [
      'ssl',
      'crt /etc/ssl/certs/openstack_datacentred_io.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }
  haproxy::balancermember { 'nova-compute-external':
    listening_service => 'nova-compute-external',
    server_names      => $nova_api_servers,
    ipaddresses       => $nova_api_servers,
    ports             => '8774',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  # Cinder
  haproxy::listen { 'cinder-external':
    ipaddress    => $external_bind_servers,
    mode         => 'http',
    ports        => '8776',
    bind_options => [
      'ssl',
      'crt /etc/ssl/certs/openstack_datacentred_io.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }
  haproxy::balancermember { 'cinder-external':
    listening_service => 'cinder-external',
    server_names      => $cinder_api_servers,
    ipaddresses       => $cinder_api_servers,
    ports             => '8776',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  # Horizon
  haproxy::listen { 'horizon-external':
    ipaddress    => $external_bind_servers,
    mode         => 'http',
    ports        => '443',
    bind_options => [
      'ssl',
      'crt /etc/ssl/certs/openstack_datacentred_io.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }
  haproxy::balancermember { 'horizon-external':
    listening_service => 'horizon-external',
    server_names      => $horizon_servers,
    ipaddresses       => $horizon_servers,
    ports             => '80',
    options           => 'check inter 2000 rise 2 fall 5',
  }
}
