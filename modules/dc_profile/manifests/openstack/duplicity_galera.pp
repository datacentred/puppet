# == Class: dc_profile::openstack::duplicity_galera
#
# Backs up galera to amazon S3 and Ceph
#
class dc_profile::openstack::duplicity_galera (
  $osdbmq_galera_backup_user,
  $osdbmq_galera_backup_pw,
) {

  dc_backup::dc_duplicity_job { "${::fqdn}_galera" :
    source_dir     => '/var/local/backup',
    backup_content => 'galera',
  }

  cron { "${::fqdn}_galera_dump_for_duplicity":
    command  => '/usr/local/sbin/galera_dump_for_duplicity.sh',
    user     => 'root',
    month    => '*',
    monthday => '*',
    hour     => '0',
    minute   => '0',
  }

  file { '/usr/local/sbin/galera_dump_for_duplicity.sh':
    ensure  => file,
    content => "#!/bin/bash\n/usr/bin/mysqldump -u ${osdbmq_galera_backup_user} -p${osdbmq_galera_backup_pw} --opt --all-databases | bzcat -zc > /var/local/backup/galera-`date +%Y%m%d-%H%M%S`.sql.bz2",
    mode    => '0700',
  }

  tidy { 'galera_dumps':
    path    => '/var/local/backup',
    age     => '2D',
    recurse => true,
    rmdirs  => true,
  }

}