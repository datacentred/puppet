# == Class: loadbalancer
#
# Provides a keepalived haproxy load balancer
#
class loadbalancer (
  $keepalived_interface,
  $keepalived_virtual_router_id,
  $keepalived_virtual_ipaddress,
  $haproxy_listeners,
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

  create_resources('haproxy::listen', $haproxy_listeners)

}

