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

  # Configure Ceph client
  ceph::client { 'cinder':
    perms => 'osd \"allow class-read object_prefix rbd_children, allow rwx pool=cinder.volumes, allow rwx pool=cinder.vms, allow rx pool=cinder.images\" mon \"allow r\"'
  } ~>
  # Workaround to get our rbd key into libvirt
  exec { 'set-virsh-secret-value':
    command => '/usr/bin/virsh secret-set-value --secret $(cat /etc/nova/virsh.secret) --base64 $(sed -n -e \'s/^.*key\ \= //p\' /etc/ceph/ceph.client.cinder.keyring)',
    unless  => '/usr/bin/virsh secret-list | grep $(cat /etc/nova/virsh.secret)',
  }

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
