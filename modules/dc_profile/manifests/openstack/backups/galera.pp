# == Class: dc_profile::openstack::backups::galera
#
# Galera backups (all databases) to Amazon S3 and storage.datacentred.io
#
class dc_profile::openstack::backups::galera {

  $osdbmq_galera_backup_user = hiera(osdbmq_galera_backup_user)
  $osdbmq_galera_backup_pw = hiera(osdbmq_galera_backup_pw)
  $backupuser     = hiera(osdbmq_galera_backup_user)
  $backuppassword = hiera(osdbmq_galera_backup_pw)

  dc_backup::dc_duplicity_job { "${::fqdn}_galera" :
    source_dir     => '/var/local/backup',
    backup_content => 'galera',
  }

  mysql_user { "${backupuser}@localhost":
    ensure        => present,
    password_hash => mysql_password($backuppassword),
    provider      => 'mysql',
    require       => Class['mysql::server::root_password'],
  }

  mysql_grant { "${backupuser}@localhost/*.*":
    ensure     => present,
    user       => "${backupuser}@localhost",
    table      => '*.*',
    privileges => [ 'SELECT', 'RELOAD', 'LOCK TABLES', 'SHOW VIEW' ],
    require    => Mysql_user["${backupuser}@localhost"],
  }

  cron { "${::fqdn}_galera_dump_for_duplicity":
    command  => '/usr/local/sbin/galera_dump_for_duplicity.sh',
    user     => 'root',
    month    => '*',
    monthday => '*',
    hour     => '0',
    minute   => '0',
  }

  file { '/var/local/backup':
    ensure => directory,
    mode   => '0700',
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
