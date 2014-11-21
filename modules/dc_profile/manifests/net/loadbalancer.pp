# == Class: dc_profile::net::loadbalancer
#
# Provide a load balancer across the set of nodes
#
class dc_profile::net::loadbalancer {

  include ::loadbalancer

  if ($::loadbalancer::haproxy_stats_ssl_cert != undef) {
    exec { 'create_cert_haproxy':
      command => "cat /var/lib/puppet/ssl/certs/${::fqdn}.pem /var/lib/puppet/ssl/private_keys/${::fqdn}.pem > /etc/ssl/certs/${::fqdn}.pem",
      creates => "/etc/ssl/certs/${::fqdn}.pem",
      user    => 'root',
    }
  }
}