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

  contain cephdeploy::mon
  contain dc_ceph::exports
  contain dc_ceph::keybackup

  Class['cephdeploy::mon'] ->
  Class['dc_ceph::exports'] ->
  Class['dc_ceph::keybackup']

}
