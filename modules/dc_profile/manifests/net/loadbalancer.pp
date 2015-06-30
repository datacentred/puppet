# == Class: dc_profile::net::loadbalancer
#
# Provide a load balancer across the set of nodes
#
class dc_profile::net::loadbalancer {

  # Include sysctls to potentiall allow binding of VIPs
  # to non-local IP addresses.  Inclusion without hiera
  # data is a noop, so safe
  include ::sysctls
  include ::loadbalancer
  include ::dc_icinga::hostgroup_haproxy

  Class['::sysctls'] ->
  Class['::loadbalancer']

}
