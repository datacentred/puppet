# == Class: dc_icinga::hostgroup_http
#
class dc_icinga::hostgroup_http {
  external_facts::fact { 'dc_hostgroup_http': }
}
