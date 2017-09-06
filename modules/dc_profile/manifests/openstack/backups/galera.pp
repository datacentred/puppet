# == Class: dc_profile::openstack::backups::galera
#
# Galera backups (all databases) to Amazon S3 and storage.datacentred.io
#
class dc_profile::openstack::backups::galera {

  $_backup_user = hiera(osdbmq_galera_backup_user)
  $_backup_pw   = hiera(osdbmq_galera_backup_pw)
  $_backup_dir  = hiera(osdbmq_galera_backup_dir)

  include ::xtrabackup

  dc_backup::dc_duplicity_job { "${::fqdn}_galera":
    source_dir     => $_backup_dir,
    backup_content => 'galera',
  }

  mysql_user { "${_backup_user}@localhost":
    ensure        => present,
    password_hash => mysql_password($_backup_pw),
    provider      => 'mysql',
    require       => Class['mysql::server::root_password'],
  }

  mysql_grant { "${_backup_user}@localhost/*.*":
    ensure     => present,
    user       => "${_backup_user}@localhost",
    table      => '*.*',
    privileges => [ 'SELECT', 'RELOAD', 'LOCK TABLES', 'SHOW VIEW' ],
    require    => Mysql_user["${_backup_user}@localhost"],
  }

  file { $_backup_dir:
    ensure => directory,
    mode   => '0700',
  }

  tidy { 'galera_dumps':
    path    => $_backup_dir,
    age     => '2D',
    recurse => true,
    rmdirs  => true,
  }

}
