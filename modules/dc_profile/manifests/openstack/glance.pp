# == Class: dc_profile::openstack::glance
#
# OpenStack image service
#
# NB: Ceph client configuration lives in a seperate profile class
#
class dc_profile::openstack::glance {

  include ::glance::keystone::auth
  include ::glance::api
  include ::glance::registry
  include ::glance::notify::rabbitmq
  include ::glance::cache::pruner
  include ::glance::cache::cleaner
  include ::glance::policy
  include ::dc_icinga::hostgroup_glance

  # TODO: Remove post-upgrade
  file_line { 'glance_api_auth_version':
    ensure => absent,
    path   => '/etc/glance/glance-api.conf',
    line   => 'auth_version=V2.0',
    notify => Service['glance-api'],
  }

  file_line { 'glance_registry_auth_version':
    ensure => absent,
    path   => '/etc/glance/glance-registry.conf',
    line   => 'auth_version=V2.0',
    notify => Service['glance-registry'],
  }

  $_ipaddress = foreman_primary_ipaddress()

  # Add this node into our loadbalancers
  @@haproxy::balancermember { "${::fqdn}-glance-registry":
    listening_service => 'glance-registry',
    server_names      => $::hostname,
    ipaddresses       => $_ipaddress,
    ports             => '9191',
    options           => 'check inter 2000 rise 2 fall 5',
  }
  @@haproxy::balancermember { "${::fqdn}-glance-api":
    listening_service => 'glance-api',
    server_names      => $::hostname,
    ipaddresses       => $_ipaddress,
    ports             => '9292',
    options           => 'check inter 2000 rise 2 fall 5',
  }

}
