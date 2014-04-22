# Class: dc_profile::ceph::mon
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
class dc_profile::ceph::mon {

  contain dc_ceph
  contain dc_ceph::mon

  Class['dc_ceph'] ->
  Class['dc_ceph::mon']

}
