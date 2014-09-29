# == Class: dc_icinga::hostgroup_lmsensors
#
class dc_icinga::hostgroup_lmsensors {
  external_facts::fact { 'dc_hostgroup_lmsensors': }
}
