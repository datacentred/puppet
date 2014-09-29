# == Class: dc_icinga::hostgroup_smtp
#
class dc_icinga::hostgroup_smtp {
  external_facts::fact { 'dc_hostgroup_smtp': }
}
