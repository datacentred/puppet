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

  include ::ceph
  include ::cinder
  include ::cinder::keystone::auth
  include ::cinder::api
  include ::cinder::scheduler
  include ::cinder::glance
  include ::cinder::quota
  include ::cinder::volume
  include ::cinder::backends
  include ::cinder::ceilometer
  include ::cinder::volume::rbd
  include ::dc_icinga::hostgroup_cinder

  # Add this node into our loadbalancer
  @@haproxy::balancermember { "${::fqdn}-cinder":
    listening_service => 'cinder',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress,
    ports             => '8776',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  # Ensure Ceph is configured before we do anything with Cinder, and
  # restart the cinder-volume service if anything changes
  Class['::ceph'] ~> Class['::cinder::volume']

  $rbd_user        = 'cinder'
  $rbd_secret_uuid = '42991612-85dc-42e4-ae3c-49cf07e98b70'

  cinder::backend::rbd { 'cinder.volumes':
    rbd_pool        => 'cinder.volumes',
    rbd_user        => $rbd_user,
    rbd_secret_uuid => $rbd_secret_uuid,
    extra_options   => {
      'cinder.volumes/storage_availability_zone' => {
        'value' => 'Production',
      },
    },
  }

  cinder::backend::rbd { 'cinder.volumes.flash':
    rbd_pool        => 'cinder.volumes.flash',
    rbd_user        => $rbd_user,
    rbd_secret_uuid => $rbd_secret_uuid,
    extra_options   => {
      'cinder.volumes.flash/storage_availability_zone' => {
        'value' => 'Production',
      },
    },
  }

}
