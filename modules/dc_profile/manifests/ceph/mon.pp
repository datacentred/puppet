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

}
