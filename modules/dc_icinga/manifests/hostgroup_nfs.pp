# == Class: dc_icinga::hostgroup_nfs
#
class dc_icinga::hostgroup_nfs {
  external_facts::fact { 'dc_hostgroup_nfs': }
}
