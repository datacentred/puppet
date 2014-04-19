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
class dc_rails(
  $app_name,
  $app_url,
  $app_repo,
  $password = undef,
  $db_password = undef,
  $secret_key_base = undef,
  $ssl_key = undef,
  $ssl_cert = undef,
  $user = 'rails',
  $group = 'rails',
  $rails_env = 'production',
  $ruby = '2.0.0-p451',
) {

  $home = "/home/${user}/"
  $app_home = "${home}${app_name}/"
  $bundler = "${home}.rbenv/shims/bundle"
  $unicorn = "${home}.rbenv/shims/unicorn"
  $log_base = '/var/log/rails/'
  $logdir = "${log_base}${app_name}/"
  $run_base = '/var/run/rails/'
  $rundir = "${run_base}${app_name}/"

  class { 'redis': }

  class { 'nginx': manage_repo => false }

  nginx::resource::upstream { $app_name:
    ensure  => present,
    members => [
      "unix://${rundir}unicorn.sock",
    ],
  } ->

  nginx::resource::vhost { $app_url:
    ensure   => present,
    proxy    => "http://${app_name}",
    ssl      => true,
    ssl_cert => $ssl_cert,
    ssl_key  => $ssl_key,
  }

  package { 'git' :
    ensure => present,
    name   => 'git-core',
  } ->

  user { $user :
    ensure     => present,
    groups     => 'sudo',
    shell      => '/bin/bash',
    managehome => true,
    home       => $home,
    password   => $password,
  } ->

  file { "${home}.ssh" :
    ensure => 'directory',
    owner  => $user,
    group  => $group,
    mode   => '0700',
  } ->

  file { [$log_base, $run_base]:
    ensure => directory,
    owner  => $user,
    group  => $group,
  } ->

  file { [$logdir, $rundir]:
    ensure => directory,
    owner  => $user,
    group  => $group,
  } ->

  file { $app_home :
    ensure => directory,
    owner  => $user,
    group  => $group;
  } ->

  git::repo{$app_name:
    path   => $app_home,
    source => $app_repo,
    owner  => $user,
    update => true,
  } ->

  file { "${logdir}${rails_env}.log" :
    owner  => $user,
    group  => $group,
    mode   => '0666',  
  } ->

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

  class{'ruby::dev':} ->

  package { 'libmariadbclient-dev' :
    ensure => present,
  } ->

  exec { 'bundle install --deployment':
    command     => "${bundler} install --deployment",
    cwd         => $app_home,
    group       => $group,
    user        => $user,
    tries       => 3,
  } ->

  exec { 'bundle binstubs unicorn':
    command     => "${bundler} binstubs unicorn",
    cwd         => $app_home,
    group       => $group,
    user        => $user,
  } ->

  class { 'dc_mariadb': 
    maria_root_pw => $db_password
  } ->

  exec { 'rake db:create':
    command     => "${bundler} exec rake db:create",
    cwd         => $app_home,
    group       => $group,
    user        => $user,
    environment => "RAILS_ENV=${rails_env}",
  } ->

  exec { 'rake db:migrate':
    command     => "${bundler} exec rake db:migrate",
    cwd         => $app_home,
    group       => $group,
    user        => $user,
    environment => "RAILS_ENV=${rails_env}",
  } ->

  exec { 'rbenv-init':
    command     => "/bin/bash -c 'eval \"$(rbenv init -)\"'",
    cwd         => $app_home,
    group       => $group,
    user        => $user,
  } ->

  unicorn::app { $app_name:
    approot          => $app_home,
    pidfile          => "${$rundir}unicorn.pid",
    socket           => "${$rundir}unicorn.sock",
    user             => $user,
    config_file      => "${app_home}config/unicorn.rb",
    logdir           => $logdir,
    group            => $group,
    preload_app      => false,
    rack_env         => $rails_env,
    secret_key_base  => $secret_key_base,
    source           => $unicorn,
    subscribe =>  [
                   Nginx::Resource::Upstream[$app_name],
                   Nginx::Resource::Vhost[$app_url],
                  ],
  }


}