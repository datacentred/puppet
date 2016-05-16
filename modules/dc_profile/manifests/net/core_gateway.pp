# == Class: dc_profile::net::core_gateway
#
# Haproxy and Keepalived configuration for core gateways
#
class dc_profile::net::core_gateway {

  include ::puppet
  include ::haproxy
  include ::keepalived
  include ::puppetcrl_sync

  File['/var/lib/puppet/ssl/crl.pem'] ~> Service['haproxy']

  # Manage the haproxy user and add it to the puppet group
  # so that haproxy can use the puppet CRL
  user { 'haproxy':
    ensure  => present,
    groups  => [ 'puppet' ],
    require => Package['haproxy'],
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

}
