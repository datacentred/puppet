# Define: dc_ceph::provision::partition
#
# Disk partition table and ceph partition creation
#
# Parameters:
#
# $name - device name, /dev/$name e.g. sdb
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
define dc_ceph::provision::partition {

  exec { "mktable /dev/${name}":
    command => "parted -a optimal --script /dev/${name} mktable gpt",
    unless  => "parted --script /dev/${name} print | egrep -sq 'Partition Table: gpt'",
    path    => [ '/bin', '/sbin' ],
  } ->

  exec { "mkpart /dev/${name}1":
    command => "parted -a optimal -s /dev/${name} mkpart ceph 0% 100%",
    unless  => "parted /dev/${name} print | egrep '^ 1.*ceph$'",
    path    => [ '/bin', '/sbin' ],
  }

}
