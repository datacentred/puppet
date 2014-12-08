# == Class: dc_icinga::hostgroup_lsyncd
#
class dc_icinga::hostgroup_lsyncd {
  external_facts::fact { 'dc_hostgroup_lsyncd': }
}
