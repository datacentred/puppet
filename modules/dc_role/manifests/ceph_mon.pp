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
class dc_role::ceph_mon inherits dc_role {

  contain dc_profile::ceph::mon

}
