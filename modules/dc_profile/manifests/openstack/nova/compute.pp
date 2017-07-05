# Class: dc_profile::openstack::nova::compute
#
# OpenStack Nova compute profile class
#
# Parameters:
#
# Actions:
#
# Requires: nova, neutron, vswitch
#
# Sample Usage:
#
class dc_profile::openstack::nova::compute {

  include ::nova
  include ::nova::compute
  include ::nova::compute::libvirt
  include ::nova::compute::neutron
  include ::nova::network::neutron
  include ::nova::scheduler::filter
  include ::nova::config
  include ::dc_profile::openstack::nova::apparmor

  include ::sysctls

  ensure_packages(['qemu-kvm'])

  # Make sure the Nova instance / image cache has the right permissions set
  file { 'nova_instance_cache':
    path    => '/var/lib/nova/instances',
    owner   => 'nova',
    group   => 'nova',
    require => Class['::Nova'],
  }

  # Manage the user so we can set the shell
  user { 'nova':
    ensure  => present,
    shell   => '/bin/bash',
    require => Package['nova-common'],
  }

  file { '/var/lib/nova/.ssh/config':
    ensure => file,
    owner  => 'nova',
    group  => 'nova',
    mode   => '0600',
  }

  ssh_config { 'StrictHostKeyChecking':
    value   => 'no',
    target  => '/var/lib/nova/.ssh/config',
    host    => '*',
    require => File['/var/lib/nova/.ssh/config'],
  }

  ssh_config { 'UserKnownHostsFile':
    value   => '/dev/null',
    target  => '/var/lib/nova/.ssh/config',
    host    => '*',
    require => File['/var/lib/nova/.ssh/config'],
  }

  # Default limit on number of open FDs is too low
  # for VMs with multiple Ceph-backed disks attached
  file { '/etc/init/libvirt-bin.override':
    ensure  => present,
    user    => 'root',
    group   => 'root',
    mode    => '0644',
    content => 'limit nofile 65535 65535',
    notify  => Service['libvirt-bin'],
  }

}
