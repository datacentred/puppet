# == Class: dc_postgresql::backup
#
# Postgresql configuration for clustering
#
class dc_postgresql::backup {

  include ::dc_postgresql::params

  # We're either the master or not a cluster member so apply the backup config unless we're on vagrant
  if $::virtual != 'virtualbox' {

    Ssh_authorized_key <<| tag == 'barman' |>>

    file { "${dc_postgresql::params::pghome}/.ssh/config":
        ensure  => file,
        content => template('dc_postgresql/backup_ssh_config.erb'),
        owner   => 'postgres',
        group   => 'postgres',
        mode    => '0600',
    }

  }

  $backup_server_ip = get_ip_addr("${dc_postgresql::params::backup_server}.${::domain}")

  postgresql::server::config_entry { 'archive_command':
    value => "rsync -a %p barman@${dc_postgresql::params::backup_server}:${dc_postgresql::params::backup_path}/${::hostname}/incoming/%f",
  }

  postgresql::server::pg_hba_rule { 'allow barman to access all db':
    description => "Open up all for access from ${dc_postgresql::params::backup_server}",
    type        => 'host',
    database    => 'all',
    user        => 'postgres',
    address     => "${backup_server_ip}/32",
    auth_method => 'md5',
    order       => '099',
  }

  @@barman::server { $::hostname:
    conninfo     => "user=postgres host=${::hostname} password=${dc_postgresql::params::postgres_password}",
    ssh_command  => "ssh postgres@${::hostname}",
    compression  => 'bzip2',
    custom_lines => 'retention_policy = RECOVERY WINDOW OF 7 DAYS',
    tag          => postgres_backup_config,
  }

}
