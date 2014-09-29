# == Class: dc_icinga::hostgroup_neutron_node
#
class dc_icinga::hostgroup_neutron_node {
  external_facts::fact { 'dc_hostgroup_neutron_node': }
}
