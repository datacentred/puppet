# Class: dc_profile::stronghold::node::queue
#
# Configure a Stronghold queue node
#
class dc_profile::stronghold::node::queue {
  include ::memcached
  include ::redis
  include dc_profile::stronghold::firewall
  include dc_profile::stronghold::monitoring

  $main_queue_options = "-e ${::environment} -c 7 -q default -q mailers -g default"

  dc_rails::application { 'stronghold':
    environment_variables => hiera(stronghold::environment_variables),
    repository_url        => 'git@github-stronghold:datacentred/stronghold.git',
    user                  => 'rails',
  } ~>

  dc_rails::service { 'sidekiq_stronghold':
    description       => 'Stronghold\'s background queue processor',
    type              => 'simple',
    environment_file  => '/etc/default/stronghold.env',
    command           => "/usr/local/bin/bundle exec sidekiq ${main_queue_options}",
    working_directory => '/home/rails/stronghold',
  } ~>

  dc_rails::service { 'sidekiq_stronghold_slow':
    description       => 'Stronghold\'s background queue processor for slow jobs',
    type              => 'simple',
    environment_file  => '/etc/default/stronghold.env',
    command           => "/usr/local/bin/bundle exec sidekiq --tag slow -e ${::environment} -c 1 -q slow",
    working_directory => '/home/rails/stronghold',
  } ~>

  dc_rails::service { 'clockwork_stronghold':
    description       => 'Stronghold\'s scheduling service',
    type              => 'simple',
    environment_file  => '/etc/default/stronghold.env',
    command           => '/usr/local/bin/bundle exec clockwork clock.rb',
    working_directory => '/home/rails/stronghold',
  }

  firewall { '070 allow Redis':
    ensure => 'present',
    proto  => tcp,
    action => 'accept',
    dport  => 6379,
    source => hiera(web_ip_v4),
  }

  firewall { '070 allow Redis (v6)':
    ensure   => 'present',
    proto    => tcp,
    action   => 'accept',
    dport    => 6379,
    source   => hiera(web_ip_v6),
    provider => 'ip6tables',
  }

  firewall { '080 allow Memcached':
    ensure => 'present',
    proto  => tcp,
    action => 'accept',
    dport  => 11211,
    source => hiera(web_ip_v4),
  }

  firewall { '080 allow Memcached (v6)':
    ensure   => 'present',
    proto    => tcp,
    action   => 'accept',
    dport    => 11211,
    source   => hiera(web_ip_v6),
    provider => 'ip6tables',
  }
}
