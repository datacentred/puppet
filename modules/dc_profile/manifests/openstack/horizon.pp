# Class: dc_profile::openstack::horizon
#
# Class to deploy the OpenStack dashboard
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::horizon {

  $keystone_host = get_exported_var('', 'keystone_host', ['localhost'])
  $horizon_secret_key = hiera(horizon_secret_key)

  $cache_server = '127.0.0.1'
  $cache_port   = '11211'

  class { 'memcached':
    listen_ip => $cache_server,
    tcp_port  => $cache_port,
    udp_port  => $cache_port,
  }
  contain 'memcached'

  class { '::horizon':
    cache_server_ip       => $cache_server,
    cache_server_port     => $cache_port,
    secret_key            => $horizon_secret_key,
    keystone_url          => "http://${keystone_host}:5000/v2.0",
    keystone_default_role => '_member_',
    django_debug          => true,
    api_result_limit      => 1000,
    neutron_options       => { 'enable_lb' => true, 'enable_vpn' => true },
  }
  contain 'horizon'

  class { '::dc_branding::openstack::horizon':
    require => Class['::horizon'],
  }
  contain 'dc_branding::openstack::horizon'

  # Logstash config
  include dc_profile::openstack::horizon_logstash

}
