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
class dc_ceph::osd (
  $journal_disk,
  $journal_size,
  $num_osds,
){

  Exec {
    path => '/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin',
  }

  package { 'xfsprogs':
    ensure => installed,
  } ->

  file { '/usr/local/bin/journal-provision':
    source => 'puppet:///modules/dc_ceph/provision.py',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  } ->

  exec { "/usr/local/bin/journal-provision ${journal_disk} ${num_osds} ${journal_size}":
    unless => "[ `sgdisk -p ${journal_disk}|grep osd|wc -l` -eq ${num_osds} ]",
  }

}
