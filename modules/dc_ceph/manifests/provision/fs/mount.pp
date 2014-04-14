# Define: dc_ceph::provision::fs::mount
#
# Create OSD mount point and mount the filesystem
#
# Parameters:
#
# $name - name of the device to mount e.g. sdb
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
define dc_ceph::provision::fs::mount {
  
  $mountpoint = "/mnt/${name}1"

  file { $mountpoint:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  } ->

  mount { $mountpoint:
    ensure  => mounted,
    atboot  => true,
    device  => "/dev/${name}1",
    fstype  => $dc_ceph::params::fs_type,
    options => $dc_ceph::params::fs_mount_opts,
  }


}
