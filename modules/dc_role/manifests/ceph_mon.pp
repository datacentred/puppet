# Class: dc_role::ceph_mon
#
# Instantiates a ceph monitor node
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::ceph_mon {

  contain dc_profile::ceph::mon

}
