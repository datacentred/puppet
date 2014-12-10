# Class: dc_profile::openstack::horizon
#
# Class to deploy the OpenStack dashboard
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::horizon {

  include ::horizon
  include ::dc_branding::openstack::horizon

  Class['::horizon'] ->
  Class['::dc_branding::openstack::horizon']

  # Add this node into our loadbalancer
  @@haproxy::balancermember { "${::fqdn}-horizon":
    listening_service => 'horizon',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress,
    ports             => '80',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  unless $::is_vagrant {
    if $::environment == 'production' {
      include dc_profile::openstack::horizon_logstash
    }
  }

}
