# Class: dc_ceph::provision::fs::btrfs
#
# Disk partition table and ceph partition creation
#
# Parameters:
#
# $devices - list of devices to provision e.g. [ sdb, sdc, sdd ]
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_ceph::provision::fs::btrfs (
  $devices = undef,
) {

  include dc_ceph::params

  package { 'btrfs-tools':
    ensure => $dc_ceph::params::btrfs_version,
  }

  dc_ceph::provision::fs::btrfs::partition { $devices:
    require => Package['btrfs-tools'],
  }
}
