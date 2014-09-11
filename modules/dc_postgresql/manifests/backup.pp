# Class: dc_postgresql::backup
#
# Server side configuration for barman backups
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
class dc_postgresql::backup {

  include ::dc_postgresql::params

  if $::virtual != 'virtualbox' and ( ( $dc_postgresql::params::cluster_master_node != $::fqdn ) or ( ! member($dc_postgresql::params::cluster_standby_nodes, $::fqdn))) {

    # Add configuration for WAL archiving and barman backup

    postgresql::server::config_entry { 'wal_level':
      value => 'archive'
    }

    postgresql::server::config_entry { 'archive_mode':
      value => 'on'
    }

    postgresql::server::config_entry { 'archive_command':
      value => "rsync -a %p barman@${dc_postgresql::params::backup_server}:${dc_postgresql::params::backup_path}/${::hostname}/incoming/%f"
    }

    postgresql::server::pg_hba_rule { 'allow barman to access all db':
      description => "Open up all for access from ${dc_postgresql::params::backup_server}",
      type        => 'host',
      database    => 'all',
      user        => 'postgres',
      address     => template('dc_postgresql/getipaddr.erb'),
      auth_method => 'md5',
    }
  }

}

