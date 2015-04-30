# == Class: loadbalancer
#
# Provides a keepalived haproxy load balancer
#
class loadbalancer (
  $keepalived_interfaces,
  $haproxy_listeners,
) {

  # Contain these classes as certificate generation may
  # need to come before provisionage of these classes
  contain ::haproxy
  contain ::keepalived
  contain loadbalancer::stats

  $keepalived_defaults = {
    'state'    => 'SLAVE',
    'priority' => 100,
  }
  create_resources('keepalived::vrrp::instance', $keepalived_interfaces, $keepalived_defaults)
  create_resources('haproxy::listen', $haproxy_listeners)

  include dc_icinga::hostgroup_haproxy
}

