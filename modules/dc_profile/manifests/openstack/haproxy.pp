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
  $novnc_proxy_servers   = get_exported_var('', 'novnc_proxy_host', ['localhost'])
  $ceilometer_api_servers = get_exported_var('', 'ceilometer_api', ['localhost'])

  $galera_cluster_members = hiera(osdbmq_members)

  $haproxy_stats_user     = hiera(haproxy_stats_user)
  $haproxy_stats_password = hiera(haproxy_stats_password)

  # Ensure HAProxy is restarted whenever SSL certificates are changed
  Class['dc_ssl::haproxy'] ~> Haproxy::Listen <||>

  # Allow Linux to bind to IPs which don't yet exist
  sysctl { 'net.ipv4.ip_nonlocal_bind':
    ensure    => present,
    value     => '1',
  }

  # Redirect all non-SSL requests to SSL
  haproxy::listen { 'http-to-https-redirect':
    ipaddress => '*',
    mode      => 'http',
    ports     => '80',
    options   => {
      'redirect' => 'scheme https if !{ ssl_fc }',
    }
  }

  # HAProxy Statistics
  haproxy::listen { 'haproxy-stats':
    ipaddress    => '*',
    mode         => 'http',
    ports        => '1936',
    bind_options => [
      'ssl',
      'crt /etc/ssl/certs/STAR_datacentred_io.pem',
      'crt /etc/ssl/certs/STAR_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'stats'  => [
        'enable',
        'uri /',
        'hide-version',
        "auth ${haproxy_stats_user}:${haproxy_stats_password}",
      ],
      'rspadd' => 'Strict-Transport-Security:\ max-age=60',
    },
  }

  # Keystone Auth
  haproxy::listen { 'keystone-auth':
    ipaddress    => '*',
    mode         => 'http',
    ports        => '5000',
    bind_options => [
      'ssl',
      'crt /etc/ssl/certs/STAR_datacentred_io.pem',
      'crt /etc/ssl/certs/STAR_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }
  haproxy::balancermember { 'keystone-auth':
    listening_service => 'keystone-auth',
    server_names      => $keystone_api_servers,
    ipaddresses       => $keystone_api_servers,
    ports             => '5000',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  # Keystone Admin
  haproxy::listen { 'keystone-admin':
    ipaddress    => '*',
    mode         => 'http',
    ports        => '35357',
    bind_options => [
      'ssl',
      'crt /etc/ssl/certs/STAR_datacentred_io.pem',
      'crt /etc/ssl/certs/STAR_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }
  haproxy::balancermember { 'keystone-admin':
    listening_service => 'keystone-admin',
    server_names      => $keystone_api_servers,
    ipaddresses       => $keystone_api_servers,
    ports             => '35357',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  # Glance API
  haproxy::listen { 'glance-api':
    ipaddress    => '*',
    mode         => 'http',
    ports        => '9292',
    bind_options => [
      'ssl',
      'crt /etc/ssl/certs/STAR_datacentred_io.pem',
      'crt /etc/ssl/certs/STAR_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'   => ['tcpka', 'httpchk', 'tcplog'],
      'balance'  => 'source',
      'rspadd'   => 'Strict-Transport-Security:\ max-age=60',
    },
  }
  haproxy::balancermember { 'glance-api':
    listening_service => 'glance-api',
    server_names      => $glance_api_servers,
    ipaddresses       => $glance_api_servers,
    ports             => '9292',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  # Glance Registry
  haproxy::listen { 'glance-registry':
    ipaddress    => '*',
    mode         => 'http',
    ports        => '9191',
    bind_options => [
      'ssl',
      'crt /etc/ssl/certs/STAR_datacentred_io.pem',
      'crt /etc/ssl/certs/STAR_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }
  haproxy::balancermember { 'glance-registry':
    listening_service => 'glance-registry',
    server_names      => $glance_api_servers,
    ipaddresses       => $glance_api_servers,
    ports             => '9191',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  # Neutron
  haproxy::listen { 'neutron':
    ipaddress    => '*',
    mode         => 'http',
    ports        => '9696',
    bind_options => [
      'ssl',
      'crt /etc/ssl/certs/STAR_datacentred_io.pem',
      'crt /etc/ssl/certs/STAR_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }
  haproxy::balancermember { 'neutron':
    listening_service => 'neutron',
    server_names      => $neutron_api_servers,
    ipaddresses       => $neutron_api_servers,
    ports             => '9696',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  # Nova Compute
  haproxy::listen { 'nova-compute':
    ipaddress    => '*',
    mode         => 'http',
    ports        => '8774',
    bind_options => [
      'ssl',
      'crt /etc/ssl/certs/STAR_datacentred_io.pem',
      'crt /etc/ssl/certs/STAR_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }
  haproxy::balancermember { 'nova-compute':
    listening_service => 'nova-compute',
    server_names      => $nova_api_servers,
    ipaddresses       => $nova_api_servers,
    ports             => '8774',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  # Nova Metadata
  haproxy::listen { 'nova-metadata':
    ipaddress    => '*',
    mode         => 'http',
    ports        => '8775',
    bind_options => [
      'ssl',
      'crt /etc/ssl/certs/STAR_datacentred_io.pem',
      'crt /etc/ssl/certs/STAR_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
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
    ipaddress    => '*',
    mode         => 'http',
    ports        => '8776',
    bind_options => [
      'ssl',
      'crt /etc/ssl/certs/STAR_datacentred_io.pem',
      'crt /etc/ssl/certs/STAR_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
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
    ipaddress    => '*',
    mode         => 'http',
    ports        => '443',
    bind_options => [
      'ssl',
      'crt /etc/ssl/certs/STAR_datacentred_io.pem',
      'crt /etc/ssl/certs/STAR_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }
  haproxy::balancermember { 'horizon':
    listening_service => 'horizon',
    server_names      => $horizon_servers,
    ipaddresses       => $horizon_servers,
    ports             => '80',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  # NoVNC Proxy
  haproxy::listen { 'novncproxy':
    ipaddress    => '*',
    mode         => 'http',
    ports        => '6080',
    bind_options => [
      'ssl',
      'crt /etc/ssl/certs/STAR_datacentred_io.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }
  haproxy::balancermember { 'novncproxy':
    listening_service => 'novncproxy',
    server_names      => $novnc_proxy_servers,
    ipaddresses       => $novnc_proxy_servers,
    ports             => '6080',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  # Galera
  haproxy::listen { 'galera':
    ipaddress    => '*',
    mode         => 'tcp',
    ports        => '3306',
    options      => {
      'option'  => ['httpchk'],
      'balance' => 'source',
    },
  }
  haproxy::balancermember { 'galera':
    listening_service => 'galera',
    server_names      => $galera_cluster_members,
    ipaddresses       => $galera_cluster_members,
    ports             => '3306',
    options           => 'check port 9200 inter 2000 rise 2 fall 5',
  }

  # Ceilometer
  #haproxy::listen { 'ceilometer':
  #  ipaddress    => '*',
  #  mode         => 'http',
  #  ports        => '8777',
  #  bind_options => [
  #    'ssl',
  #    'crt /etc/ssl/certs/STAR_datacentred_io.pem',
  #    'crt /etc/ssl/certs/STAR_sal01_datacentred_co_uk.pem',
  #    'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
  #  ],
  #  options      => {
  #    'option'  => ['tcpka', 'tcplog'],
  #    'balance' => 'source',
  #    'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
  #  },
  #}
  #haproxy::balancermember { 'ceilometer':
  #  listening_service => 'ceilometer',
  #  server_names      => $ceilometer_api_servers,
  #  ipaddresses       => $ceilometer_api_servers,
  #  ports             => '8777',
  #  options           => 'check inter 2000 rise 2 fall 5',
  #}

  #include dc_icinga::hostgroup_haproxy
}
