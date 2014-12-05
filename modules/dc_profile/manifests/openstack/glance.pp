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

  contain ::glance::api
  contain ::glance::registry
  contain ::glance::backend::rbd
  contain ::glance::notify::rabbitmq
  include ::glance::cache::pruner
  include ::glance::cache::cleaner

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

  include ::dc_nrpe::glance
  include ::dc_icinga::hostgroup_glance

  unless $::is_vagrant {
    if $::environment == 'production' {
      include ::dc_profile::openstack::glance_logstash
    }
  }

}
