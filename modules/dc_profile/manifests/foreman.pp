class dc_profile::foreman {

  class { '::foreman':
    foreman_url           => $::fqdn,
    authentication        => true,
    passenger             => true,
    use_vhost             => true,
    ssl                   => true,
    db_manage             => true,
    db_type               => 'postgresql',
    db_username           => 'foreman',
    db_password           => 'tH1sI5ap45sW0rD',
    oauth_active          => true,
    oauth_consumer_key    => 'you_shall_not_pass',
    oauth_consumer_secret => 't3H_84lr0G',
  }

}
