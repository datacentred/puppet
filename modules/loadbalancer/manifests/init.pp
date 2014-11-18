# == Class: loadbalancer
#
# Provides a keepalived haproxy load balancer
#
class loadbalancer (
  $keepalived_interfaces,
  $haproxy_listeners,
  $haproxy_stats_user = undef,
  $haproxy_stats_password = undef,
  $haproxy_stats_ipaddress = undef,
) {

  include ::haproxy
  include ::keepalived
  include ::dc_ssl::haproxy

  $keepalived_defaults = {
    'state'    => 'SLAVE',
    'priority' => 100,
  }
  create_resources('keepalived::vrrp::instance', $keepalived_interfaces, $keepalived_defaults)

  if $haproxy_stats_ipaddress != undef {
    haproxy::listen { 'haproxy-stats':
      ipaddress => $haproxy_stats_ipaddress,
      mode      => 'http',
      ports     => '1936',
      options   => {
        'stats'  => [
          'enable',
          'uri /',
          'hide-version',
          "auth ${haproxy_stats_user}:${haproxy_stats_password}",
        ],
        'rspadd' => 'Strict-Transport-Security:\ max-age=60',
      },
    }
  }

  create_resources('haproxy::listen', $haproxy_listeners)

}

