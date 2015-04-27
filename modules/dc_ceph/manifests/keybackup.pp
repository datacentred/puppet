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

    contain dc_backup::gpg_keys

    file { '/var/ceph-keybackup':
      ensure  => directory,
    }

    tidy { '/var/ceph-keybackup':
      age     => '1w',
      recurse => true,
      rmdirs  => true,
    }

    dc_backup::dc_duplicity_job { $::hostname :
      pre_command    => 'ceph auth list &> /var/ceph-keybackup/keys'
      source_dir     => '/var/ceph-keybackup',
      backup_content => 'cephkey',
    }

  }

}
