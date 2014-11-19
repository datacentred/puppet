# == Class: dc_profile::net::loadbalancer
#
# Provide a load balancer across the set of nodes
#
class dc_profile::net::loadbalancer{

  include ::loadbalancer
  include ::dc_ssl::haproxy

}
