# == Class: dc_icinga::hostgroup_beaver
#
# Users of the beaver
#
class dc_icinga::hostgroup_beaver {
  external_facts::fact { 'dc_hostgroup_beaver': }
}
