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

  include dc_profile::auth::sudoers_nova

  # Make sure the Nova instance / image cache has the right permissions set
  file { 'nova_instance_cache':
    path    => '/var/lib/nova/instances',
    owner   => 'nova',
    group   => 'nova',
    require => Class['::Nova'],
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

  # Ensure 10GbE interfaces are properly configured
  $integration = 'p1p1'
  $ceph_storage = 'p1p2'

  augeas { $integration:
    context => '/files/etc/network/interfaces',
    changes => [
        "set auto[child::1 = '${integration}']/1 ${integration}",
        "set iface[. = '${integration}'] ${integration}",
        "set iface[. = '${integration}']/family inet",
        "set iface[. = '${integration}']/method dhcp",
        # Now set via DHCP
        "rm iface[. = '${integration}']/pre-up '/sbin/ip link set ${integration} mtu 9000'",
    ],
  }

  augeas { $ceph_storage:
    context => '/files/etc/network/interfaces',
    changes => [
        "set auto[child::1 = '${ceph_storage}']/1 ${ceph_storage}",
        "set iface[. = '${ceph_storage}'] ${ceph_storage}",
        "set iface[. = '${ceph_storage}']/family inet",
        "set iface[. = '${ceph_storage}']/method dhcp",
        # Now set via DHCP
        "rm iface[. = '${ceph_storage}']/pre-up '/sbin/ip link set ${ceph_storage} mtu 9000'",
    ],
  }

  unless $::is_vagrant {
    if $::environment == 'production' {
      # Logstash config
      include ::dc_logstash::client::nova_compute
      include ::dc_logstash::client::libvirt
    }
  }

}
