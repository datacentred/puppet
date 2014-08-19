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

  include ::ceph::mon
  include ::dc_ceph::exports
  include ::dc_ceph::keybackup

  Class['ceph::mon'] ->
  Class['dc_ceph::exports'] ->
  Class['dc_ceph::keybackup']

}
