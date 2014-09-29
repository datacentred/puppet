# == Class: dc_icinga::hostgroup_glance
#
class dc_icinga::hostgroup_glance {
  external_facts::fact { 'dc_hostgroup_glance': }
}
