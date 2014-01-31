class dc_profile::keystone {

  $keystone_db_pw = hiera(keystone_db_pw)

  # Install the sever to listen on the chosen address range
  class { '::postgresql::server':
    ip_mask_deny_postgres_user   => '0.0.0.0/32',
    listen_addresses             => '*',
  }

  # A test database for Nagios to probe
  postgresql::server::db { 'nagiostest':
    user     => 'nagios',
    password => 'nagios',
    require  => Class['::postgresql::server'],
  }

  # Keystone database
  postgresql::server::db { 'keystone':
    user     => 'keystone',
    password => $keystone_db_pw,
    grant    => 'all',
    require  => Class['::postgresql::server'],
  }

  # Add configuration for WAL archiving and barman backup

  $pgbackupserver = hiera(pg_backup_server)
  $barmanpath     = hiera(barman_path)

  postgresql::server::config_entry { 'wal_level':
    value => 'archive'
  }

  postgresql::server::config_entry { 'archive_mode':
    value => 'on'
  }

  postgresql::server::config_entry { 'archive_command':
    value => "rsync -a %p barman@${pgbackupserver}:${barmanpath}/${::hostname}/incoming/%f"
  }

  include dc_icinga::hostgroups
  realize Dc_external_facts::Fact::Def['dc_hostgroup_postgres']

}
