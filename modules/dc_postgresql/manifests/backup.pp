# == Class: dc_postgresql::backup
#
# Postgresql configuration for clustering
#
class dc_postgresql::backup {

  file { '/root/.pgpass':
    ensure  => file,
    content => "#hostname:port:database:username:password\nlocalhost:5432:*:postgres:${::dc_postgresql::postgres_password}\n",
    mode    => '0600',
    owner   => 'root',
  }

  postgresql::server::pg_hba_rule { 'allow replication access to local postgres user':
    description => 'Open up all for replication from local postgres user',
    type        => 'local',
    database    => 'replication',
    user        => 'postgres',
    auth_method => 'md5',
    order       => '099',
  }

  dc_backup::dc_duplicity_job { "${::fqdn}_postgresql_base" :
    pre_command    => 'pg_basebackup --pgdata=/var/postgres_base_dump/$(date +\%F)/ --format=tar --gzip --username=postgres --no-password > /dev/null',
    source_dir     => '/var/postgres_base_dump',
    backup_content => 'postgresql_base',
  }

  tidy { 'postgres_base_dump':
    path    => '/var/postgres_base_dump',
    age     => '7D',
    recurse => true,
    rmdirs  => true,
  }

}
