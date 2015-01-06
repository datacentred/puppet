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
  include ::cinder::ceilometer
  include ::cinder::volume::rbd

  include dc_profile::auth::sudoers_cinder

  ceph::client { 'cinder':
    perms => 'osd \"allow class-read object_prefix rbd_children, allow rwx pool=cinder.volumes, allow rwx pool=cinder.vms, allow rx pool=glance\" mon \"allow r\"'
  }

  # Ensure Ceph is configured before we do anything with Cinder, and
  # restart the cinder-volume service if anything changes
  Ceph::Client['cinder'] ~>
  Class['::cinder::volume']

  # Add this node into our loadbalancer
  @@haproxy::balancermember { "${::fqdn}-cinder":
    listening_service => 'cinder',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress,
    ports             => '8776',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  include ::dc_icinga::hostgroup_cinder

  unless $::is_vagrant {
    if $::environment == 'production' {
      include ::dc_logstash::client::cinder
    }
  }

}
