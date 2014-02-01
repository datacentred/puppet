# Class: dc_postgresql::pg_backupconfig
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
class dc_postgresql::pg_backupconfig (
  $pgbackupserver,
  $barmanpath,
){

  # Add configuration for WAL archiving and barman backup

  postgresql::server::config_entry { 'wal_level':
    value => 'archive'
  }

  postgresql::server::config_entry { 'archive_mode':
    value => 'on'
  }

  postgresql::server::config_entry { 'archive_command':
    value => "rsync -a %p barman@${pgbackupserver}:${barmanpath}/${::hostname}/incoming/%f"
  }

  postgresql::server::pg_hba_rule { 'allow barman to access all db':
    description => "Open up all for access from ${pgbackupserver}",
    type        => 'host',
    database    => 'all',
    user        => 'postgres',
    address     => template('dc_postgresql/getipaddr.erb'),
    auth_method => 'password',
  }

}

