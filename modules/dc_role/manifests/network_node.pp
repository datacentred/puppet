# Class: dc_role::openstack::network_node
#
# OpenStack Network Node role definition
#
# Parameters: none
#
# Actions: Configures Neutron agent plugins for the network node
# use-case.
#
# Requires: network_node should be set at global scope
# via Host Groups in Foreman
#
# Sample Usage:
#
class dc_role::network_node {

  contain dc_profile::openstack::neutron_agent
  contain dc_profile::openstack::neutron_common

  include dc_icinga::hostgroup_neutron_node

}
