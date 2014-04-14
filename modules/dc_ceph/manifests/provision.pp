# Class: dc_ceph::provision
#
# Ceph hard drive provisioner
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_ceph::provision {

  include dc_ceph::params

  # Source: custom fact
  $devices = split($::ceph_devices, ',')

  # Generic partitioning
  dc_ceph::provision::partition { $devices: } ->

  # File system specific creation and mounting
  class { "dc_ceph::provision::fs::${dc_ceph::params::fs_type}":
    devices => $devices,
  }
  contain "dc_ceph::provision::fs::${dc_ceph::params::fs_type}"

}
