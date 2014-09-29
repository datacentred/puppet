# == Class: dc_icinga::hostgroup_keystone
#
class dc_icinga::hostgroup_keystone {
  external_facts::fact { 'dc_hostgroup_keystone': }
}
