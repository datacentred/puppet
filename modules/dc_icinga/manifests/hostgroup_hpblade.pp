# == Class: dc_icinga::hostgroup_hpblade
#
class dc_icinga::hostgroup_hpblade {
  external_facts::fact { 'dc_hostgroup_hpblade': }
}
