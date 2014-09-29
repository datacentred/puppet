# == Class: dc_icinga::hostgroup_nova_server
#
class dc_icinga::hostgroup_nova_server {
  external_facts::fact { 'dc_hostgroup_nova_server': }
}
