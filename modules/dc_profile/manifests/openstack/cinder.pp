# Class: dc_profile::openstack::cinder
#
# OpenStack Cinder - block storage service
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::cinder {

  include ::cinder
  include ::cinder::api
  include ::cinder::scheduler
  include ::cinder::glance
  include ::cinder::quota
  include ::cinder::volume
  include ::cinder::volume::rbd

  # Add this node into our loadbalancer
  @@haproxy::balancermember { "${::fqdn}-cinder":
    listening_service => 'icehouse-cinder',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress,
    ports             => '8776',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  unless $::is_vagrant {
    include ::dc_profile::openstack::cinder_nagios
    if $::environment == 'production' {
      include ::dc_profile::openstack::cinder_logstash
    }
  }

}
