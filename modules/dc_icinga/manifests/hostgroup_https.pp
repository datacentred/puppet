# == Class: dc_icinga::hostgroup_https
#
class dc_icinga::hostgroup_https {
  external_facts::fact { 'dc_hostgroup_https': }
}
