# Class: dc_ceph::osd
#
# Responsible for defining which devices get ceph installed
# on them and detecting which SSD is used as journal storage
# for each drive
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_ceph::osd {

  $devices = hiera("ceph_osd_${::hostgroup}")

  ceph::osd { $devices: }

}
