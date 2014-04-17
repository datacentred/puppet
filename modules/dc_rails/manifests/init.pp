# Class: dc_rails
#
# Setup a Rails server
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
class dc_rails {

  $user = 'rails'
  $password = 'secret'
  $group = 'rails'
  $home = '/home/rails/'
  $ruby = '2.0.0-p451'
  $app_home = '/home/rails/soleman'
  $app_repo = 'https://github.com/seanhandley/helloworld.git'

  package { 'git' :
    ensure => present,
    name   => 'git-core',
  }

  group { 'sudo' :
    ensure => present,
  }

  user { $user :
    ensure     => present,
    groups     => 'sudo',
    shell      => '/bin/bash',
    managehome => true,
    home       => $home,
    password   => $password,
    require    => Group['sudo']
  }

  class { 'sudo': }
    sudo::conf { 'rails_sudo':
    priority => 10,
    content  => "${user} ALL=(ALL) NOPASSWD: ALL",
  }

  file { '/home/rails/.ssh' :
    ensure => 'directory',
    owner  => $user,
    group  => $group,
    mode   => '0700',
  }

  class { 'dc_mariadb': }

  class { 'nginx': manage_repo => false }

  nginx::resource::upstream { 'rails':
    members => [
      'unix:///var/run/rails/unicorn.sock',
    ],
  } ->

  nginx::resource::vhost { 'soleman.dev':
    proxy => 'http://rails',
  }

  include ::ruby
  include ::bundler
  contain 'ruby'
  contain 'bundler'

  rbenv::install { $user:
    group => $group,
    home  => $home,
  } ->

  rbenv::compile { $ruby:
    user   => $user,
    home   => $home,
    global => true,
  } ->

  rbenv::gem { 'unicorn':
    user => $user,
    ruby => $ruby,
  } ->

  file { $app_home :
    ensure => directory,
    owner  => $user,
    group  => $group;
  } ->

  git::repo{'soleman':
    path   => $app_home,
    source => $app_repo,
    owner  => $user,
  } ->

  package { 'libmariadbclient-dev' :
    ensure => present,
  } ->

  exec { 'bundle install --deployment':
    command     => '/home/rails/.rbenv/shims/bundle install --deployment',
    cwd         => $app_home,
    group       => $group,
    user        => $user,
  } ->

  exec { 'rake db:create':
    command     => '/home/rails/.rbenv/shims/bundle exec rake db:create',
    cwd         => $app_home,
    group       => $group,
    user        => $user,
    environment => 'RAILS_ENV=production',
  } ->

  exec { 'rake db:migrate':
    command     => '/home/rails/.rbenv/shims/bundle exec rake db:migrate',
    cwd         => $app_home,
    group       => $group,
    user        => $user,
    environment => 'RAILS_ENV=production',
  } ->

  file { ['/var/log/rails/', '/var/run/rails/']:
    ensure => directory,
    owner  => $user,
    group  => $group;
  } ->

  file { '/home/rails/soleman/log/production.log' :
    owner  => $user,
    group  => $group,
    mode   => '0666',  
  } ->

  unicorn::app { 'soleman':
    approot          => $app_home,
    pidfile          => '/var/run/rails/unicorn.pid',
    socket           => '/var/run/rails/unicorn.sock',
    user             => $user,
    config_file      => '/home/rails/soleman/config/unicorn.rb',
    logdir           => '/var/log/rails',
    group            => $group,
    preload_app      => false,
    rack_env         => 'production',
    secret_key_base  => '91fe5d494f16b1f3bff432c65d1b30a39e8881c0e842ab607f78f44260ea27f5da3b7c24b5347a57c3059858435b8fc6b2f918bc8fb516c34caecd7810aea7e0',
    source           => '/home/rails/.rbenv/shims/unicorn',
    require          => [
      Class['ruby::dev'],
    ],
  }
}