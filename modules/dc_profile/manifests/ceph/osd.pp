# Class: dc_profile::ceph::osd
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
class dc_profile::ceph::osd {

  include ::dc_ceph::osd
  include ::ceph::osd
  include ::dc_icinga::hostgroup_ceph_osd

  # Proprietary additions first to partition the
  # journal SSDs
  Class['dc_ceph::osd'] ->
  Class['ceph::osd']

}
