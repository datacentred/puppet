# == Class: dc_backups::duplicity_puppetcerts
#
# Backs up all the puppetcerts to swift and (encrypted) to S3
#
class dc_backup::duplicity_puppetcerts (
  $backup_source_dir,
  $backup_content,
) {

  dc_backup::dc_duplicity_job { "${::hostname}_ceph" :
    source_dir     => $backup_source_dir,
    cloud          => 'ceph',
    backup_content => $backup_content,
  }

  dc_backup::dc_duplicity_job { "${::hostname}_s3" :
    source_dir     => $backup_source_dir,
    cloud          => 's3',
    backup_content => $backup_content,
  }

}
