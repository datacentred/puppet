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
  }

  # Workaround to get our rbd key into libvirt
  exec { 'set-virsh-secret-value':
    command     => '/usr/bin/virsh secret-set-value --secret $(cat /etc/nova/virsh.secret) --base64 $(sed -n -e \'s/^.*key\ \= //p\' /etc/ceph/ceph.client.cinder.keyring)',
    onlyif      => '/usr/bin/virsh secret-list | grep $(cat /etc/nova/virsh.secret)',
    subscribe   => File['/etc/ceph/ceph.client.cinder.keyring'],
    refreshonly => true,
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

  if $::environment == 'production' {
    # Logstash config
    include ::dc_profile::openstack::nova_compute_logstash
    include ::dc_nrpe::nova_compute
  }

}
