# == Class: dc_icinga::hostgroup_ceph_osd
#
class dc_icinga::hostgroup_ceph_osd {
  external_facts::fact { 'dc_hostgroup_ceph_osd': }
}
