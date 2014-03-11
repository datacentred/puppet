# Class: dc_profile::db::pgbackup
#
# Something else to do with backups
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::db::pgbackup {

  $storagedir = hiera(storagedir)
  $db0_postgres_pw = hiera(postgresql_password)
  $keystone_postgres_pw = hiera(keystone_postgres_pw)

  if $::barman_key {

    $key_elements = split($::barman_key, ' ')

    @@ssh_authorized_key { "barman_key_${::hostname}" :
      ensure  => present,
      type    => 'ssh-rsa',
      key     => $key_elements[1],
      user    => 'postgres',
      options => "from=\"${::ipaddress}\"",
      tag     => barman,
    }

  }

  class { 'barman':
    home    => hiera(barman_path),
  }

  barman::server { 'db0':
    conninfo     => "user=postgres host=db0 password=${db0_postgres_pw}",
    ssh_command  => 'ssh postgres@db0',
    compression  => 'bzip2',
    custom_lines => 'retention_policy = RECOVERY WINDOW OF 7 DAYS'
  }

  Ssh_authorized_key <<| tag == 'postgres' |>>

  cron { 'barman-backup-friday':
    ensure  => present,
    command => '/usr/bin/barman backup all',
    weekday => '5',
    hour    => '2',
    minute  => '0',
    user    => 'barman',
    require => Class['barman'],
  }

  cron { 'barman-backup-tuesday':
    ensure  => present,
    command => '/usr/bin/barman backup all',
    weekday => '2',
    hour    => '2',
    minute  => '0',
    user    => 'barman',
    require => Class['barman'],
  }

}
