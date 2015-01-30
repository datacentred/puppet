# == Class: dc_icinga::hostgroup_supermicro
#
class dc_icinga::hostgroup_supermicro {
  external_facts::fact { 'dc_hostgroup_supermicro': }
}
