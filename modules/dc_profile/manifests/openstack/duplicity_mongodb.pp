# == Class: dc_profile::openstack::duplicity_mongodb
#
# Backs up mongodb to amazon S3 and Ceph
#
class dc_profile::openstack::duplicity_mongodb (
  $ceilometer_db_password,
) {

  dc_backup::dc_duplicity_job { "${::fqdn}_mongodb" :
    source_dir     => '/srv/backup/mongodb',
    backup_content => 'ceilometer',
  }

  cron { "${::fqdn}_mongodb_dump_for_duplicity":
    command  => '/usr/local/sbin/mongodb_dump_for_duplicity.sh > /dev/null',
    user     => 'root',
    month    => '*',
    monthday => '*',
    hour     => '0',
    minute   => '0',
  }

  file { '/usr/local/sbin/mongodb_dump_for_duplicity.sh':
    ensure  => file,
    content => "#!/bin/bash\n/usr/bin/mongodump --db ceilometer --username ceilometer --password ${ceilometer_db_password} --out /srv/backup/mongodb/",
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
  }

  file { '/srv/backup/mongodb':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  tidy { 'mongodb_dumps':
    path    => '/srv/backup/mongodb/',
    age     => '2D',
    recurse => true,
    rmdirs  => true,
  }

}
