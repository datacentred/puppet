# Class: dc_ceph::params
#
# Common parameters for ceph
#
# Parameters:
#
# $fs_type       - file system to generate.  Supported values are:
#                  btrfs
#
# $btrfs_version - version of btrfs to install, passed to
#                  package::ensure
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_ceph::params (
  $fs_type       = 'btrfs',
  $btrfs_version = present,
) {

  # Intentionally blank, override the defaults with either
  # hiera data binding or ENC class parameters

}
