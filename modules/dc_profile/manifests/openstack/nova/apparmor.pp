# Class: dc_profile::openstack::nova::apparmor
#
# OpenStack apparmor configuration for libvirt
#
# Parameters:
#
# Actions:
#
#
# Sample Usage:
#
class dc_profile::openstack::nova::apparmor {

  # Install modified libvirt-qemu configuration for apparmor
  file { 'libvirt-qemu-apparmor':
    path   => '/etc/apparmor.d/abstractions/libvirt-qemu',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/dc_openstack/libvirt-qemu',
    notify => [ Service['libvirt'], Service['nova-compute'], Service['apparmor'] ],
  }

}
