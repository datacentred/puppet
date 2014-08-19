# == Class: dc_role::radosgw
#
# A rados gateway
#
class dc_role::radosgw {

  include ::dc_profile::ceph::radosgw
  contain 'dc_profile::ceph::radosgw'

}
