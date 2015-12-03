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

  File {
    owner  => 'root',
    group  => 'root',
  }

  # OSD location hook script
  file { '/usr/local/bin/location_hook.py':
    mode   => '0755',
    source => 'puppet:///modules/dc_ceph/location_hook.py',
  }

  file { '/usr/local/etc/location_hook.ini':
    mode    => '0644',
    content => template('dc_ceph/location_hook.ini.erb'),
  }

}
