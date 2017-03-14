# Class: dc_rails::application
#
# Configure a Rails application environment
#
define dc_rails::application(
  $environment_variables = undef,
  $repository_url        = undef,
  $user                  = undef
){
  include dc_rails::ruby

  $db_password = $environment_variables['db_password']

  sudo::conf { 'sudo':
    ensure  => present,
    content => '%sudo   ALL=(ALL) NOPASSWD:ALL',
  } ->

  user { $user:
    ensure     => 'present',
    managehome => true,
    groups     => ['sudo'],
    system     => true,
  } ->

  file_line { 'rails_console command':
    ensure => 'present',
    line   => "rails_console() { set -o allexport; source /etc/default/${name}.env; set +o allexport;\
               cd /home/${user}/${name}; bundle exec rails c ${::environment}; }",
    path   => "/home/${user}/.bashrc",
  } ->

  file { "/home/${user}/.ssh":
    ensure => 'directory',
    owner  => $user,
    group  => $user,
    mode   => '0700',
  } ->

  file { "/home/${user}/.ssh/id_rsa":
    ensure  => present,
    owner   => $user,
    group   => $user,
    mode    => '0600',
    content => hiera(stronghold::repo_key),
  } ->

  file { '/root/.ssh/assets':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => hiera(stronghold::repo_key),
  } ->

  file { "/home/${user}/.ssh/id_rsa2":
    ensure  => present,
    owner   => $user,
    group   => $user,
    mode    => '0600',
    content => hiera(stronghold::harbour::repo_key),
  } ->

  file { "/home/${user}/.ssh/config":
    ensure  => present,
    owner   => $user,
    group   => $user,
    mode    => '0600',
    content => hiera(stronghold::ssh_config),
  } ->

  sshkey { 'github.com':
    ensure => 'present',
    key    => hiera(github::known_host_entry),
    type   => 'ssh-rsa',
  }

  file { "/var/log/${user}":
    ensure => 'directory',
    owner  => $user,
    group  => 'root',
    mode   => '0660',
  } ->

  file { "/var/log/${user}/stronghold":
    ensure => 'directory',
    owner  => $user,
    group  => 'root',
    mode   => '0660',
  } ->

  file { "/var/log/${user}/${name}/production.log":
    ensure => present,
    owner  => $user,
    group  => 'root',
    mode   => '0660'
  } ->

  file { "/etc/default/${name}.env":
    ensure  => file,
    owner   => 'root',
    group   => 'rails',
    mode    => '0640',
    content => template('dc_rails/environment.erb'),
  } ->

  vcsrepo { "/home/${user}/${name}":
    ensure   => latest,
    provider => git,
    source   => $repository_url,
    user     => $user,
  } ~>

  ruby::bundle { "bundle install ${name}":
    user        => $user,
    group       => $user,
    option      => '--deployment',
    cwd         => "/home/${user}/${name}",
    timeout     => 600,
    tries       => 3,
    refreshonly => true,
  } ~>

  ruby::bundle { "bundle exec rails db:create ${name}":
    command     => 'exec',
    user        => $user,
    group       => $user,
    option      => 'rails db:create',
    cwd         => "/home/${user}/${name}",
    environment => "DB_PASSWORD=${db_password}",
    rails_env   => $::environment,
    refreshonly => true,
  } ~>

  ruby::bundle { "bundle exec rails db:migrate ${name}":
    command     => 'exec',
    user        => $user,
    group       => $user,
    option      => 'rails db:migrate',
    cwd         => "/home/${user}/${name}",
    environment => "DB_PASSWORD=${db_password}",
    rails_env   => $::environment,
    refreshonly => true,
  }
}
