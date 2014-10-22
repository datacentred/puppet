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

  include ::nova
  include ::nova::compute
  include ::nova::compute::libvirt
  include ::nova::compute::neutron
  include ::nova::compute::rbd
  include ::nova::network::neutron

  if $::environment == 'production' {

  # Logstash config
  include dc_profile::openstack::nova_compute_logstash

  file { '/etc/nagios/nrpe.d/nova_compute.cfg':
    ensure  => present,
    content => 'command[check_nova_compute_proc]=/usr/lib/nagios/plugins/check_procs -c 1: -u nova -a nova-compute',
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server'],
  }
}

}
