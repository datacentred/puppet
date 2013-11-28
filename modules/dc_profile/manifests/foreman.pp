# Class to provision foreman with a separate database node
class dc_profile::foreman {

  $foreman_pw = hiera(foreman_pw)

  class { '::foreman':
    foreman_url           => $::fqdn,
    authentication        => true,
    passenger             => true,
    use_vhost             => true,
    ssl                   => true,
    db_manage             => false,
    db_type               => 'postgresql',
    db_host               => 'postgres.sal01.datacentred.co.uk',
    db_database           => 'foreman',
    db_username           => 'foreman',
    db_password           => $foreman_pw,
    oauth_active          => true,
    oauth_consumer_key    => 'you_shall_not_pass',
    oauth_consumer_secret => 't3H_84lr0G',
  }

  # As the database is remote and unmanaged by the class
  # we need to explicitly set up all the tables, as we're not great
  # with puppet yet just do it unconditionally, doesn't seem to have
  # any detrimental effects...
  exec { 'explicit_dbmigrate':
    command     => '/usr/share/foreman/extras/dbmigrate',
    user        => 'foreman',
    environment => 'HOME=/usr/share/foreman',
    logoutput   => 'on_failure',
  }

}
