# This is a bit of a hack at present, will clean it up on due course
# For posterity and humour this comment was written 12/12/2013 - SM
class dc_profile::coredb {

  $puppetdb_pw = hiera(puppetdb_pw)
  $foreman_pw  = hiera(foreman_pw)
  $keystone_db_pw = hiera(keystone_db_pw)

  # Install the sever to listen on the chosen address range
  class { '::postgresql::server':
    ip_mask_allow_all_users      => '10.10.192.0/24',
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
    password => $keystone_pw,
    grant    => 'all',
    require  => Class['::postgresql::server'],
  }

  # Create the puppetdb user as this cannot be done from provisioning
  postgresql::server::db { 'puppetdb':
    user     => 'puppetdb',
    password => $puppetdb_pw,
    grant    => 'all',
    require  => Class['::postgresql::server'],
  }

  # Create the foreman user as this cannot be done from provisioning
  postgresql::server::db { 'foreman':
    user     => 'foreman',
    password => $foreman_pw,
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
