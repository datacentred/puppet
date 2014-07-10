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
class dc_role::compute_node {

  contain dc_profile::openstack::neutron_agent
  contain dc_profile::openstack::neutron_common
  contain dc_profile::openstack::nova_compute
  contain dc_profile::supermicro::ipmi

  Class['dc_profile::openstack::neutron_agent'] ->
  Class['dc_profile::openstack::nova_compute']

  include dc_icinga::hostgroup_nova_compute

}
