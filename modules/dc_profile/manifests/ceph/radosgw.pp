# == Class: dc_profile::ceph::radosgw
#
# Profile for deployment of a rados gateway
#
class dc_profile::ceph::radosgw {

  include ::dc_nrpe::ceph
  include ::dc_icinga::hostgroup_ceph_rgw

  contain ::ceph::radosgw
  contain ::loadbalancer::members

}
