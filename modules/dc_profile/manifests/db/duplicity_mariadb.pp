# == Class: dc_profile::db::duplicity_mariadb
#
# Backs up mariadb to amazon S3 and Ceph
#
class dc_profile::db::duplicity_mariadb {

  dc_backup::dc_duplicity_job { "${::hostname}_mariadb" :
    source_dir     => '/var/dbbackups',
    backup_content => 'mariadb',
  }

}