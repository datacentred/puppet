# == Class: dc_backups::duplicity_mariadb
#
# Backs up mariadb backups to swift and to (encrypted) S3
#
class dc_backup::duplicity_mariadb (
  $backup_source_dir,
  $backup_content,
) {

  dc_backup::dc_duplicity_job { "${::hostname}_ceph" :
    source_dir     => $backup_source_dir,
    backup_content => $backup_content,
  }

  dc_backup::dc_duplicity_job { "${::hostname}_s3" :
    source_dir     => $backup_source_dir,
    backup_content => $backup_content,
  }

}
