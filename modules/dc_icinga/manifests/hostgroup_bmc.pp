# == Class: dc_icinga::hostgroup_bmc
#
class dc_icinga::hostgroup_bmc {
  external_facts::fact { 'dc_hostgroup_bmc': }
}
