# == Class: loadbalancer
#
# Provides a keepalived haproxy load balancer
#
class loadbalancer (
  $keepalived_interface,
  $keepalived_virtual_router_id,
  $keepalived_virtual_ipaddress,
  $haproxy_listeners,
  $haproxy_stats_user,
  $haproxy_stats_password,
) {

  include ::haproxy
  include ::keepalived
  include ::dc_ssl::haproxy

  keepalived::vrrp::instance { "VI_${keepalived_virtual_router_id}":
    interface         => $keepalived_interface,
    state             => 'SLAVE',
    priority          => '100',
    virtual_router_id => $keepalived_virtual_router_id,
    virtual_ipaddress => $keepalived_virtual_ipaddress,
  }

  # HAProxy Statistics
  haproxy::listen { 'haproxy-stats':
    ipaddress => '*',
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

  create_resources('haproxy::listen', $haproxy_listeners)

}

