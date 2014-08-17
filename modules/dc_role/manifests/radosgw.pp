# == Class: dc_role::radosgw
#
# A rados gateway
#
class dc_roll::radosgw {

  include ::dc_profile::radosgw
  contain 'dc_profile::radosgw'

}
