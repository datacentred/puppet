# == Class: dc_icinga::hostgroup_ceph_mon
#
class dc_icinga::hostgroup_ceph_mon {
  external_facts::fact { 'dc_hostgroup_ceph_mon': }
}
