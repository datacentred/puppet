# == Class: dc_profile::openstack::duplicity_mongodb
#
# Backs up mongodb to amazon S3 and Ceph
#
class dc_profile::openstack::duplicity_mongodb (
  $ceilometer_db_password,
) {

  dc_backup::dc_duplicity_job { "${::hostname}_mongodb" :
    pre_command    => "/usr/bin/mongodump --db ceilometer --username ceilometer --password ${ceilometer_db_password} --out /srv/backup/",
    source_dir     => '/srv/backup',
    backup_content => 'ceilometer',
  }

}
