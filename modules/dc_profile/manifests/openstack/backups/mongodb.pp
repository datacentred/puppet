# == Class: dc_profile::openstack::backups::mongodb
#
# Ceilometer MongoDB replicaset to Amazon S3 and storage.datacentred.io
#
class dc_profile::openstack::backups::mongodb {

  $ceilometer_db_password = hiera(ceilometer_db_password)

  ensure_packages(['mongodb-org-tools'])

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

  file { ['/srv/backup', '/srv/backup/mongodb']:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/usr/local/sbin/mongodb_dump_for_duplicity.sh':
    ensure  => file,
    content => "#!/bin/bash\n/usr/bin/mongodump --db ceilometer --username ceilometer --password ${ceilometer_db_password} --out /srv/backup/mongodb/",
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
    require => Package['mongodb-org-tools'],
  }

  tidy { 'mongodb_dumps':
    path    => '/srv/backup/mongodb/',
    age     => '2D',
    recurse => true,
    rmdirs  => true,
  }

}
