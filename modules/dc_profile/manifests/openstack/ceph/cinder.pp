# == Class: dc_profile::openstack::ceph::cinder
#
# Ceph client configuration for the Cinder service
#
class dc_profile::openstack::ceph::cinder {
  include ::ceph
  include ::cinder::volume::rbd
  
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
