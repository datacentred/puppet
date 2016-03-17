# == Class: dc_profile::ceph::radosgw
#
# Profile for deployment of a rados gateway
#
class dc_profile::ceph::radosgw {

  include ::dc_icinga::hostgroup_ceph_rgw

  include ::ceph
  include ::dc_ceph::rgw

  Class['::ceph'] ->
  Class['::dc_ceph::rgw']

}
