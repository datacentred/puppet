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
      'localhost:8080',
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

  file { ['/var/log/rails/', '/var/run/rails/']:
    ensure => directory,
    owner  => $user,
    group  => $group;
  } ->

  unicorn::app { 'soleman':
    approot     => $app_home,
    pidfile     => '/var/run/rails/unicorn.pid',
    socket      => '/var/run/rails/unicorn.sock',
    user        => $user,
    config_file => '/home/rails/soleman/config/unicorn.rb',
    logdir      => '/var/log/rails/',
    group       => $group,
    preload_app => false,
    rack_env    => 'production',
    #source      => 'bundler',
    require     => [
      Class['ruby::dev'],
    ],
  }
}