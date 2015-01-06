# Class: dc_role::compute_node
#
# OpenStack Compute role - nova-compute, neutron-agent
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::compute_node inherits dc_role {

  contain dc_profile::openstack::neutron_agent
  contain dc_profile::openstack::nova_compute
  contain dc_profile::openstack::ceilometer_agent
  contain dc_profile::openstack::nova_apparmor

  Class['dc_profile::openstack::neutron_agent'] ->
  Class['dc_profile::openstack::nova_compute'] ->
  Class['dc_profile::openstack::ceilometer_agent']

  include dc_icinga::hostgroup_nova_compute

}
