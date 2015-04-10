# == Class: dc_backup::duplicity_dnsbackups
#
# Backs up dns records to swift and (encrypted) to S3
#
class dc_backup::duplicity_dnsbackups (
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
