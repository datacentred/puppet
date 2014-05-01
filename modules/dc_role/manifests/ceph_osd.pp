# Class: dc_role::ceph_osd
#
# Instantiates a ceph osd node
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::ceph_osd {

  contain dc_profile::ceph::osd

}
