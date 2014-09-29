# == Class: dc_icinga::hostgroup_foreman
#
class dc_icinga::hostgroup_foreman {
  external_facts::fact { 'dc_hostgroup_foreman': }
}
