# Class: dc_profile::openstack::glance
#
# Openstack image API and registry server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::glance {

  include ::glance::keystone::auth
  include ::glance::api
  include ::glance::registry
  include ::glance::backend::rbd
  include ::glance::notify::rabbitmq
  include ::glance::cache::pruner
  include ::glance::cache::cleaner
  include ::glance::policy
  include ::dc_icinga::hostgroup_glance

  # Add this node into our loadbalancers
  @@haproxy::balancermember { "${::fqdn}-glance-registry":
    listening_service => 'glance-registry',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress,
    ports             => '9191',
    options           => 'check inter 2000 rise 2 fall 5',
  }
  @@haproxy::balancermember { "${::fqdn}-glance-api":
    listening_service => 'glance-api',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress,
    ports             => '9292',
    options           => 'check inter 2000 rise 2 fall 5',
  }

}
