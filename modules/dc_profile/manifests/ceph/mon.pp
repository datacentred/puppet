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

  contain ceph::mon
  contain dc_ceph::exports
  contain dc_ceph::keybackup

  Class['ceph::mon'] ->
  Class['dc_ceph::exports'] ->
  Class['dc_ceph::keybackup']

}
