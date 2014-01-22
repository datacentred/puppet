# This is for a stand alone 'HA' PostgreSQL instance which is used
# by puppetdb and foreman
class dc_profile::postgresql (
  $client_mask = '10.10.192.0/24',
) {

  $puppetdb_pw = hiera(puppetdb_pw)
  $foreman_pw  = hiera(foreman_pw)

  # Install the sever to listen on the chosen address range
  class { '::postgresql::server':
    ip_mask_allow_all_users     => $client_mask,
    ip_mask_deny_postgres_user  => '0.0.0.0/32',
    listen_addresses            => '*',
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

}
