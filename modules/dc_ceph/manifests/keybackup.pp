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

    file { '/var/ceph-keybackup':
      ensure => directory,
    }

    file { '/usr/local/bin/cephkeybackup':
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      source => 'puppet:///modules/dc_ceph/cephkeybackup',
    }

    #percentage signs in cron job are escaped because cron subs them for newlines otherwise
    dc_backup::dc_duplicity_job { "${::fqdn}_ceph_keys" :
      pre_command    => '/usr/local/bin/cephkeybackup -o /var/ceph-keybackup/keys_`date +"\%m_\%d_\%Y"`.txt',
      source_dir     => '/var/ceph-keybackup',
      backup_content => 'ceph_keys',
    }

    dc_backup::dc_duplicity_job { "${::hostname}_ceph_keys" :
      pre_command    => '/usr/local/bin/cephkeybackup -o /var/ceph-keybackup/keys_`date +"\%m_\%d_\%Y"`.txt',
      source_dir     => '/var/ceph-keybackup',
      backup_content => 'ceph_keys',
      cloud          => 'none',
    }

    tidy { 'ceph_key_dir':
      path    => '/var/ceph-keybackup',
      age     => '7D',
      recurse => true,
      rmdirs  => true,
    }

  }

}
