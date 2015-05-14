# Class: dc_ceph::keybackup
#
# Saves the keys on the primary monitor node
# as this is needed to seed other nodes with
# cephdeploy
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_ceph::keybackup (
  $primary_mon,
) {

  if $::hostname == $primary_mon {

  dc_backup::dc_duplicity_job { "${::hostname}_ceph_keys" :
    pre_command    => 'ceph auth list > /var/ceph-keybackup/keys.txt',
    source_dir     => '/var/ceph-keybackup',
    backup_content => 'ceph_keys',
  }

  tidy { 'ceph_key_dir':
    path    => '/var/ceph-keybackup',
    age     => '7D',
    recurse => true,
    rmdirs  => true,
  }

}
