# Class: dc_profile::stronghold::node::queue
#
# Configure a Stronghold queue node
#
class dc_profile::stronghold::node::queue {
  include ::memcached
  include ::redis
  include dc_profile::stronghold::firewall

  $main_queue_options = "-e ${::environment} -c ${::sidekiq_default_workers} -q default -q mailers -g default"

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
    proto    => tcp,
    action   => 'accept',
    dport    => 6379,
    provider => ['iptables', 'ip6tables'],
    source   => hiera(web_ip),
  }

  firewall { '080 allow Memcached':
    proto    => tcp,
    action   => 'accept',
    dport    => 11211,
    provider => ['iptables', 'ip6tables'],
    source   => hiera(web_ip),
  }
}
