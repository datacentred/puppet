# == Class: dc_postgresql::duplicity_postgresql_wal
#
# Creates a script that gets run by postgres to backup all WAL files to amazon S3 and Ceph after creation
#
class dc_postgresql::duplicity_postgresql_wal {

  include ::dc_postgresql::params

  dc_backup::dc_duplicity_job { "${::hostname}_postgresql_WAL" :
    create_cron    => false,
    script_owner   => 'postgres',
    source_dir     => "${dc_postgresql::params::pgdata}/pg_xlog/",
    backup_content => 'postgresql_WAL',
    cloud          => 'dc_ceph'
  }

}