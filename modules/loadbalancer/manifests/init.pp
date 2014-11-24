# == Class: loadbalancer
#
# Provides a keepalived haproxy load balancer
#
class loadbalancer (
  $keepalived_interfaces,
  $haproxy_listeners,
) {

  include ::haproxy
  include ::keepalived

  $keepalived_defaults = {
    'state'    => 'SLAVE',
    'priority' => 100,
  }
  create_resources('keepalived::vrrp::instance', $keepalived_interfaces, $keepalived_defaults)
  create_resources('haproxy::listen', $haproxy_listeners)

}

