# == Class: dc_profile::openstack::compute
#
# Compute node top level profile
#
class dc_profile::openstack::compute {

  contain dc_profile::openstack::neutron_agent
  contain dc_profile::openstack::nova_compute
  contain dc_profile::openstack::ceilometer_agent
  contain dc_profile::openstack::nova_apparmor

  Class['dc_profile::openstack::neutron_agent'] ->
  Class['dc_profile::openstack::nova_compute'] ->
  Class['dc_profile::openstack::ceilometer_agent']

  include dc_icinga::hostgroup_nova_compute

  if $::osfamily == 'RedHat' {
    service { 'firewalld':
      ensure => 'stopped',
    }
    service { 'NetworkManager':
      ensure => 'stopped',
    }
  }

}
