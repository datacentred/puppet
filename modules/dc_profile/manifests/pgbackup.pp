class dc_profile::pgbackup {

  $storagedir = hiera(storagedir)
  $db0_postgres_pw = hiera(db0_postgres_pw)

  realize Dc_repos::Virtual::Repo['local_postgres_mirror']

  class { 'barman':
    require => Dc_repos::Virtual::Repo['local_postgres_mirror'],
    home    => '/var/storage/barman',
  }

  barman::server { 'db0':
    conninfo    => "user=postgres host=db0 password=${db0_postgres_pw}",
    ssh_command => 'ssh postgres@db0',
    compression => 'bzip2',
  }

}
