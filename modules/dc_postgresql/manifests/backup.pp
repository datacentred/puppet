# == Class: dc_postgresql::backup
#
# Postgresql configuration for clustering
#
class dc_postgresql::backup {

  include ::dc_postgresql::params

  Ssh_authorized_key <<| tag == 'barman' |>>

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
