# == Class: dc_role::radosgw
#
# A rados gateway
#
class dc_role::radosgw inherits dc_role {

  contain ::dc_profile::ceph::radosgw

}
