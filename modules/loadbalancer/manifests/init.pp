# == Class: loadbalancer
#
# Provides a keepalived haproxy load balancer 
#
class loadbalancer (
  $keepalived_interface,
  $keepalived_virtual_router_id,
  $keepalived_virtual_ipaddress,
  $haproxy_service,
  $haproxy_ipaddress,
  $haproxy_mode,
  $haproxy_ports,
  $haproxy_bind_options,
  $haproxy_options,
) {

  include ::haproxy
  include ::keepalived
  include ::dc_ssl::haproxy

  keepalived::vrrp::instance { "VI_${keepalived_virtual_router_id}":
    interface          => $keepalived_interface,
    state              => 'SLAVE',
    priority           => '100',
    virtual_router_id  => $keepalived_virtual_router_id,
    virtual_ipaddress  => $keepalived_virtual_ipaddress,
  }

  haproxy::listen { $haproxy_service:
    ipaddress    => $haproxy_ipaddress,
    mode         => $haproxy_mode,
    ports        => $haproxy_ports,
    bind_options => $haproxy_bind_options,
    options      => $haproxy_options,
  }

}

