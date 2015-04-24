# == Class: dc_icinga::hostgroup_x86
#
class dc_icinga::hostgroup_x86 {
  external_facts::fact { 'dc_hostgroup_x86': }
}
