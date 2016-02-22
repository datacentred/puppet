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

  include ::ceph
  include ::nova
  include ::nova::compute
  include ::nova::compute::libvirt
  include ::nova::compute::neutron
  include ::nova::compute::rbd
  include ::nova::network::neutron
  include ::nova::scheduler::filter
  include ::nova::config

  include ::sysctls

  # Make sure the Nova instance / image cache has the right permissions set
  file { 'nova_instance_cache':
    path    => '/var/lib/nova/instances',
    owner   => 'nova',
    group   => 'nova',
    require => Class['::Nova'],
  }

  # Ensure ceph is installed and configured before installing the cinder secret
  Class['::ceph'] -> Class['::nova::compute::rbd']

  # Make sure the Ceph client configuration is in place
  # before we do any of the Nova rbd-related configuration, and
  # restart if there's any changes
  Class['::ceph'] ~> Class['::nova::compute']

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

  case $::osfamily {
    'Debian': {
      include ::dc_profile::openstack::nova::apparmor
    }
    'RedHat': {
      service { 'firewalld':
        ensure => 'stopped',
      }
      service { 'NetworkManager':
        ensure => 'stopped',
      }
    }
    default: {}
  }

}
