# == Class: dc_profile::net::core_gateway
#
# Haproxy and Keepalived configuration for core gateways
#
class dc_profile::net::core_gateway {

  include ::puppet
  include ::haproxy
  include ::keepalived
  include ::puppetcrl_sync

  # Create the key/cert pair for haproxy
  concat { '/etc/ssl/private/puppet.crt':
    ensure => present,
    owner  => 'haproxy',
    group  => 'haproxy',
    mode   => '0440',
  }

  concat::fragment { 'haproxy puppet key':
    target => '/etc/ssl/private/puppet.crt',
    source => "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem",
    order  => '1',
  }

  concat::fragment { 'haproxy puppet cert':
    target => '/etc/ssl/private/puppet.crt',
    source => "/var/lib/puppet/ssl/certs/${::fqdn}.pem",
    order  => '2',
  }

  # Manage the haproxy user and add it to the puppet group
  # so that haproxy can use the puppet CRL
  user { 'haproxy':
    ensure => present,
    groups => [ 'puppet' ],
  }

  create_resources('haproxy::frontend', hiera_hash('dc_profile::net::core_gateway::frontends'))
  create_resources('haproxy::backend', hiera_hash('dc_profile::net::core_gateway::backends'))
  create_resources('haproxy::listen', hiera_hash('dc_profile::net::core_gateway::listeners'))
  create_resources('haproxy::balancermember', hiera_hash('dc_profile::net::core_gateway::balancermembers'))

  keepalived::vrrp::instance { 'VI_1':
    interface         => 'em1',
    state             => 'SLAVE',
    virtual_router_id => '1',
    priority          => '100',
    virtual_ipaddress => '10.30.192.2/24',
  }

  keepalived::vrrp::instance { 'VI_2':
    interface         => 'em2',
    state             => 'SLAVE',
    virtual_router_id => '2',
    priority          => '100',
    virtual_ipaddress => '185.43.217.42/29',
  }

  # Ensure the puppet certificate is available before starting the SSL service
  Concat['/etc/ssl/private/puppet.crt'] -> Class['::haproxy::service']

  # Ensure the CRL is accessible before starting the SSL service
  Class['::haproxy::install'] -> User['haproxy'] -> Class['::haproxy::service']

  # Notify haproxy if the CRL changes.
  # WARNING: won't actually kill off ports with persistent connections due to
  #          graceful switch over!!!
  Class['::puppetcrl_sync'] ~> Class['::haproxy::service']

}
