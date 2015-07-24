# == Class: dc_postgresql::duplicity_postgresql_base
#
# Runs a base backup of postgresql which is then backed up to amazon S3 and Ceph
#
class dc_postgresql::duplicity_postgresql_base {

  include ::dc_postgresql::params

  file { '/root/.pgpass':
    ensure  => file,
    content => "#hostname:port:database:username:password\nlocalhost:5432:*:postgres:${dc_postgresql::params::postgres_password}\n",
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

  dc_backup::dc_duplicity_job { "${::hostname}_postgresql_base" :
    pre_command    => 'pg_basebackup --pgdata=/var/postgres_base_dump/`date +%F`/ --format=tar --gzip --progress --username=postgres --no-password',
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
