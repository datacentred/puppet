# == Class: dc_profile::puppet::duplicity_puppetcerts
#
# Backs up puppetcerts to amazon S3 and Ceph
#
class dc_profile::puppet::duplicity_puppetcerts {

  dc_backup::dc_duplicity_job { $::hostname :
    source_dir     => '/var/lib/puppet/ssl',
    backup_content => 'puppetcerts',
  }

}