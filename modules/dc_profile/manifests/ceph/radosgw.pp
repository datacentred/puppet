# == Class: dc_profile::ceph::radosgw
#
# Profile for deployment of a rados gateway
#
class dc_profile::ceph::radosgw {

  include ::ceph::radosgw
  contain 'ceph::radosgw'

}
