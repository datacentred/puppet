# Class: dc_profile::openstack::nova::apparmor
#
# OpenStack apparmor configuration for libvirt
#
class dc_profile::openstack::nova::apparmor {

  $interested_parties = [
    'libvirt-bin',
    'nova-compute',
    'apparmor',
  ]

  Package['libvirt-bin'] ->

  file_line { 'libvirt-qemu-apparmor':
    path => '/etc/apparmor.d/abstractions/libvirt-qemu',
    line => '/var/lib/libvirt/qemu/*.sock rw,',
  } ~>

  Service[$interested_parties]

}
