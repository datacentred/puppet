# Class: dc_profile::openstack::nova_compute
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
class dc_profile::openstack::nova_compute {

  # Make sure the Nova instance / image cache has the right permissions set
  file { 'nova_instance_cache':
    path    => '/var/lib/nova/instances',
    owner   => 'nova',
    group   => 'nova',
    require => Class['::Nova'],
  }

  # Patch in the fix for revert resize deleting the rbd
  file { '/usr/lib/python2.7/dist-packages/nova/compute/manager.py':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/dc_openstack/manager.py',
    require => Package['python-nova'],
    notify  => Service['nova-compute'],
  }

  # Configure Ceph client, this installs ceph and the client keyring
  ceph::client { 'cinder':
    perms => 'osd \"allow class-read object_prefix rbd_children, allow rwx pool=cinder.volumes, allow rwx pool=cinder.vms, allow rx pool=glance\" mon \"allow r\"'
  } ->

  # Install the admin key on each host as ::nova::compute::rbd has a requirement
  # that 'ceph auth' works without specifying the keyring.
  # TODO: The hard-coded horror goes away in the next generation ceph module
  ceph::keyring { 'ceph.client.admin.keyring':
    user => 'client.admin',
    key  => hiera('ceph_admin_key'),
  }

  Ceph::Keyring['ceph.client.admin.keyring'] -> Class['::nova::compute::rbd']

  include ::nova
  include ::nova::compute
  include ::nova::compute::libvirt
  include ::nova::compute::neutron
  include ::nova::compute::rbd
  include ::nova::network::neutron
  include ::nova::scheduler::filter

  nova_config { 'serial_console/enabled':
    value => false,
  }

  # Make sure the Ceph client configuration is in place
  # before we do any of the Nova rbd-related configuration, and
  # restart if there's any changes
  Ceph::Client['cinder'] ~>
  Class['::nova::compute']

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

  package { 'sysfsutils':
    ensure => installed,
  }

  unless $::is_vagrant {
    if $::environment == 'production' {
      # Logstash config
      include ::dc_logstash::client::nova_compute
      include ::dc_logstash::client::libvirt
    }
  }

}
