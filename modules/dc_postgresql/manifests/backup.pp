# == Class: dc_postgresql::backup
#
# Postgresql configuration for clustering
#
class dc_postgresql::backup {

  include ::dc_postgresql::params

  postgresql::server::config_entry { 'archive_command':
    value => 'rsync -a %p /var/dbbackups/%f',
  }

  file { '/var/dbbackups':
    ensure => directory,
  }

  tidy { '/var/dbbackups':
    age     => '1w',
    recurse => true,
    rmdirs  => true,
  }

  dc_backup::dc_duplicity_job { $::hostname :
    source_dir     => '/var/dbbackups',
    backup_content => 'postgresql',
  }

}
