# Class: dc_profile::stronghold::node::web
#
# Configure a Stronghold web node
#
class dc_profile::stronghold::node::web {
  include dc_profile::stronghold::firewall
  include dc_profile::stronghold::monitoring
  include ::nginx

  file { '/var/run/rails':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0661',
  }

  file { '/var/run/rails/stronghold':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0661',
  }

  file { '/etc/ssl/certs/STAR_datacentred_io.pem':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => hiera(stronghold::star_datacentred_io_pem),
  }

  file { '/etc/ssl/certs/admin-my.datacentred.io-ca.crt':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => hiera(stronghold::admin_my_datacentred_io_ca_crt)
  }

  file { '/etc/ssl/certs/dhparam.pem':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => hiera(stronghold::dhparam_pem),
  }

  file { '/etc/nginx/.htpasswd':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => hiera(sirportly_htpasswd),
  }

  sshkey { "assets-cdn.${::domain}":
    ensure => 'present',
    key    => hiera(assets::known_host_entry),
    type   => 'ecdsa-sha2-nistp256',
  } ->

  dc_rails::application { 'stronghold':
    environment_variables => hiera(stronghold::environment_variables),
    repository_url        => 'git@github-stronghold:datacentred/stronghold.git',
    user                  => 'rails',
    group                 => 'docker',
  } ~>

  ruby::bundle { "bundle exec rails assets:precompile ${name}":
    command     => 'exec',
    user        => 'rails',
    group       => 'rails',
    option      => 'rails assets:precompile',
    cwd         => '/home/rails/stronghold',
    rails_env   => $::environment,
    refreshonly => true,
  } ~>

  rsync::put { hiera(rsync_destination):
    options => '-aze "ssh -o StrictHostKeyChecking=no -i /root/.ssh/assets"',
    source  => '/home/rails/stronghold/public/*',
  } ~>

  dc_rails::service { 'unicorn_stronghold':
    description       => 'Stronghold\'s web process',
    type              => 'forking',
    environment_file  => '/etc/default/stronghold.env',
    command           => "/usr/local/bin/bundle exec unicorn -D -E ${::environment} -c /home/rails/stronghold/config/unicorn.rb",
    working_directory => '/home/rails/stronghold',
    pid_file          => '/var/run/rails/stronghold/unicorn.pid',
    unicorn           => true,
  }

  firewall { '040 allow HTTP':
    ensure => 'present',
    proto  => tcp,
    action => 'accept',
    dport  => 80,
  }

  firewall { '040 allow HTTP (v6)':
    ensure   => 'present',
    proto    => tcp,
    action   => 'accept',
    dport    => 80,
    provider => 'ip6tables',
  }

  firewall { '050 allow HTTPS':
    ensure => 'present',
    proto  => tcp,
    action => 'accept',
    dport  => 443,
  }

  firewall { '050 allow HTTPS (v6)':
    ensure   => 'present',
    proto    => tcp,
    action   => 'accept',
    dport    => 443,
    provider => 'ip6tables',
  }

  docker::image { 'datacentred/docker-openstack-client':
    image_tag => 'alpine4'
  }
}
