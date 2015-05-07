# == Class: dc_profile::openstack::duplicity_galera
#
# Backs up galera to amazon S3 and Ceph
#
class dc_profile::openstack::duplicity_galera (
  $osdbmq_galera_backup_user,
  $osdbmq_galera_backup_pw,
) {

  dc_backup::dc_duplicity_job { "${::hostname}_galera" :
    pre_command    => "/usr/bin/mysqldump -u ${osdbmq_galera_backup_user} -p${osdbmq_galera_backup_pw} --opt --all-databases | bzcat -zc > /var/local/backup/galera-`date +%Y%m%d-%H%M%S`.sql.bz2",
    source_dir     => '/var/local/backup',
    backup_content => 'galera',
  }

}
