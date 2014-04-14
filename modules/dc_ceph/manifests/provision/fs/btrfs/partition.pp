# Define: dc_ceph::provision::fs::btrfs::partition
#
# Create the butter fs structures on the specified
# partition
#
# Parameters:
#
# $name - name of the device to image e.g. sdb
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
define dc_ceph::provision::fs::btrfs::partition {

  exec { "mkfs.btrfs /dev/${name}1":
    command => "mkfs.btrfs -L ceph /dev/${name}1",
    unless  => "btrfs-show /dev/${name}1 | egrep '^Label: ceph'",
    path    => [ '/bin', '/sbin' ],
  } ->

  dc_ceph::provision::fs::mount { $name: }

}
