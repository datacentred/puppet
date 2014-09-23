# Class: dc_postgresql::config
#
# Postgresql configuration for clustering
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_postgresql::config {

  include ::dc_postgresql::params
  $backup_server = "${dc_postgresql::params::backup_server}.${::domain}"

  # FIXME get the master to generate and export the cluster name

  if $dc_postgresql::params::cluster_master_node == $::hostname {

    $node_id = '0'

    postgresql::server::config_entry { 'wal_level':
      value => 'hot_standby',
    }

    postgresql::server::config_entry { 'archive_mode':
      value => 'on',
    }

    # If we have the backup server key and the backup server has our backup key we can assume it's all configured and configure our side

    if member(query_nodes("Ssh_authorized_key[barman_key_${::dc_postgresql::params::backup_server}]"), "${::hostname}.${::domain}") and member(query_nodes("Ssh_authorized_key[postgres_backup_key_${::hostname}]"), "${dc_postgresql::params::backup_server}.${::domain}") {
      postgresql::server::config_entry { 'archive_command':
        value => "rsync -a %p barman@${dc_postgresql::params::backup_server}:${dc_postgresql::params::backup_path}/${::hostname}/incoming/%f",
      }
      postgresql::server::pg_hba_rule { 'allow barman to access all db':
        description => "Open up all for access from ${dc_postgresql::params::backup_server}",
        type        => 'host',
        database    => 'all',
        user        => 'postgres',
        address     => template('dc_postgresql/getipaddr.erb'),
        auth_method => 'md5',
        order       => '099',
      }
      @@barman::server { "${::hostname}":
        conninfo     => "user=postgres host=${::hostname} password=${dc_postgresql::params::postgres_password}",
        ssh_command  => "ssh postgres@${::hostname}",
        compression  => 'bzip2',
        custom_lines => 'retention_policy = RECOVERY WINDOW OF 7 DAYS',
        tag          => postgres_backup_config,
      }
    }
    else {
      postgresql::server::config_entry { 'archive_command':
        value => 'exit 0',
      }
    }

    postgresql::server::config_entry { 'max_wal_senders':
      value => '10',
    }

    postgresql::server::config_entry { 'wal_keep_segments':
      value => '5000',
    }

    postgresql::server::config_entry { 'hot_standby':
      value => 'on',
    }

    # Create repmgr user

    postgresql::server::role { 'repmgr':
      username  => 'repmgr',
      login     => true,
      superuser => true,
    }

    # Create a repmgr database to hold the replication tables

    postgresql::server::database { 'repmgr':
      dbname  => 'repmgr',
      owner   => 'repmgr',
      require => Postgresql::Server::Role['repmgr'],
    }

    postgresql::server::database_grant { 'repmgr':
      privilege => 'ALL',
      db        => 'repmgr',
      role      => 'repmgr',
      require   => Postgresql::Server::Database['repmgr'],
    }

    file { "${dc_postgresql::params::pgdata}/../../repmgr":
      ensure  => directory,
      require => Package['postgresql-server'],
    }

    file { "${dc_postgresql::params::pgdata}/../../repmgr/repmgr.conf":
      ensure  => file,
      content => template('dc_postgresql/repmgr.conf.erb'),
      require => File["${dc_postgresql::params::pgdata}/../../repmgr"],
    }

    runonce { 'register_master_repmgr':
      command => "repmgr -f ${dc_postgresql::params::pgdata}/../../repmgr/repmgr.conf --verbose master register",
      require => [ File["${dc_postgresql::params::pgdata}/../../repmgr/repmgr.conf"], Package['repmgr'], Postgresql::Server::Database_grant['repmgr'], Postgresql::Server::Pg_hba_rule['repmgr local ipv4'] ],
    }

    # connection requirements are exported from the members of the cluster
    # realize them here

    Postgresql::Server::Pg_hba_rule <<| tag == 'slave' |>>

    # Allow repmgr access
    postgresql::server::pg_hba_rule { 'repmgr local ipv4':
      description => 'repmgr access from local ip',
      type        => 'host',
      database    => 'repmgr',
      user        => 'repmgr',
      address     => "${::ipaddress}/32",
      auth_method => 'trust',
      tag         => 'slave',
      order       => '099',
    }

  }

  elsif member($dc_postgresql::params::cluster_standby_nodes, $::hostname) {

    # Find the index in the array for this host, then increment as the master node is 0 and use this as the node_id
    $node_id = array_index($dc_postgresql::params::cluster_standby_nodes, $::hostname) + 1

    # FIXME make these users have passwords and do md5 auth

    @@postgresql::server::pg_hba_rule { "repmgr from ${::hostname}":
      description => "repmgr access from ${::hostname}",
      type        => 'host',
      database    => 'repmgr',
      user        => 'repmgr',
      address     => "${::ipaddress}/32",
      auth_method => 'trust',
      tag         => 'slave',
      order       => '099',
    }

    @@postgresql::server::pg_hba_rule { "replication from ${::hostname}":
      description => "replication access from ${::hostname}",
      type        => 'host',
      database    => 'replication',
      user        => 'repmgr',
      address     => "${::ipaddress}/32",
      auth_method => 'trust',
      tag         => 'slave',
      order       => '099',
    }

    file { "${dc_postgresql::params::pgdata}/../../repmgr":
      ensure  => directory,
      require => Package['postgresql-server'],
    }

    file { "${dc_postgresql::params::pgdata}/../../repmgr/repmgr.conf":
      ensure  => file,
      content => template('dc_postgresql/repmgr.conf.erb'),
      require => File["${dc_postgresql::params::pgdata}/../../repmgr"],
    }

    postgresql::server::config_entry { 'hot_standby':
      value => 'on',
    }
    ->
    postgresql::server::pg_hba_rule { 'repmgr local ipv4':
      description => 'repmgr access from local ip',
      type        => 'host',
      database    => 'repmgr',
      user        => 'repmgr',
      address     => "${::ipaddress}/32",
      auth_method => 'trust',
      tag         => 'slave',
      order       => '099',
      before      => Class['dc_postgresql::standby_sync'],
    }

    include 'dc_postgresql::standby_sync'
  }
  # We're not the master or a standby so just configure the basics for backup if the backup server is configured
  else {

    if member(query_nodes("Ssh_authorized_key[barman_key_${dc_postgresql::params::backup_server}]"), "${::hostname}.${::domain}") and member(query_nodes("Ssh_authorized_key[postgres_backup_key_${::hostname}]"), "$dc_postgresql::params::backup_server.${::domain}") {
      postgresql::server::config_entry { 'archive_command':
        value => "rsync -a %p barman@${dc_postgresql::params::backup_server}:${dc_postgresql::params::backup_path}/${::hostname}/incoming/%f",
      }
      postgresql::server::pg_hba_rule { 'allow barman to access all db':
        description => "Open up all for access from ${dc_postgresql::params::backup_server}",
        type        => 'host',
        database    => 'all',
        user        => 'postgres',
        address     => template('dc_postgresql/getipaddr.erb'),
        auth_method => 'md5',
        order       => '099',
      }
      @@barman::server { "${::hostname}":
        conninfo     => "user=postgres host=${::hostname} password=${dc_postgresql::params::postgres_password}",
        ssh_command  => "ssh postgres@${::hostname}",
        compression  => 'bzip2',
        custom_lines => 'retention_policy = RECOVERY WINDOW OF 7 DAYS',
        tag          => postgres_backup_config,
      }
    }
    else {
      postgresql::server::config_entry { 'archive_command':
        value => 'exit 0',
      }
    }

    postgresql::server::config_entry { 'wal_level':
      value => 'archive',
    }

    postgresql::server::config_entry { 'archive_mode':
      value => 'on',
    }
  }
}

