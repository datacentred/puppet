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
define dc_rails::app (
  $app_name,
  $app_url,
  $app_repo,
  $ssl_key,
  $ssl_cert,
  $secret_key_base,
) {

  $user = hiera(rails::user::name)
  $password = hiera(rails::user::password)
  $group = hiera(rails::user::name)
  $db_password = hiera(dc_mariadb::maria_root_pw)
  $jira_password = hiera(jira::stronghold::password)
  $strongbox_passphrase = hiera(rails::server::stronghold::api_key_passphrase)
  $rails_env = 'production'
  $ruby = '2.1.2'
  $home = "/home/${user}/"
  $app_home = "${home}${app_name}/"
  $bundler = "${home}.rbenv/shims/bundle"
  $unicorn = "${home}.rbenv/shims/unicorn"
  $log_base = '/var/log/rails/'
  $logdir = "${log_base}${app_name}/"
  $run_base = '/var/run/rails/'
  $rundir = "${run_base}${app_name}/"

  contain sudo

  class { 'dc_rails::server': } ->

  sudo::conf { $user:
    priority => 10,
    content  => "Cmnd_Alias UNICORN_CMDS = /usr/sbin/service unicorn_${app_name}, /usr/sbin/service unicorn_${app_name} start, /usr/sbin/service unicorn_${app_name} stop, /usr/sbin/service unicorn_${app_name} status, /usr/sbin/service unicorn_${app_name} restart\n${user} ALL=(ALL) NOPASSWD: UNICORN_CMDS",
  } ->

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
  } ->

  file { [$logdir, $rundir]:
    ensure => directory,
    owner  => $user,
    group  => $group,
  } ->

  file { "${logdir}${rails_env}.log" :
    owner  => $user,
    group  => $group,
    mode   => '0666',
  } ->

  file { $app_home :
    ensure => directory,
    owner  => $user,
    group  => $group;
  } ->

  vcsrepo { $app_home:
    ensure   => present,
    provider => git,
    source   => $app_repo,
    user     => $user,
  } ->

  exec { "bundle install --deployment ${app_name}":
    command     => "${bundler} install --deployment",
    cwd         => $app_home,
    group       => $group,
    user        => $user,
    timeout     => 600,
    tries       => 3,
    refreshonly => true,
    subscribe   => Vcsrepo[$app_home],
  } ->

  exec { "rake assets:precompile ${$app_name}":
    command     => "${bundler} exec rake assets:precompile",
    cwd         => $app_home,
    group       => $group,
    user        => $user,
    environment => ["RAILS_ENV=${rails_env}"],
    refreshonly => true,
    subscribe   => Vcsrepo[$app_home],
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
    db_password      => $db_password,
    source           => $unicorn,
    subscribe        => Vcsrepo[$app_home],
  } ->

  exec { "rake db:create ${$app_name}":
    command     => "${bundler} exec rake db:create",
    cwd         => $app_home,
    group       => $group,
    user        => $user,
    refreshonly => true,
    subscribe   => Vcsrepo[$app_home],
    environment => ["RAILS_ENV=${rails_env}", "DB_PASSWORD='${db_password}'"],
  } ->

  exec { "rake db:migrate ${$app_name}":
    command     => "${bundler} exec rake db:migrate",
    cwd         => $app_home,
    group       => $group,
    user        => $user,
    refreshonly => true,
    subscribe   => Vcsrepo[$app_home],
    environment => ["RAILS_ENV=${rails_env}", "DB_PASSWORD='${db_password}'"],
  } ->

  exec { "rake db:seed ${$app_name}":
    command     => "${bundler} exec rake db:seed",
    cwd         => $app_home,
    group       => $group,
    user        => $user,
    refreshonly => true,
    subscribe   => Vcsrepo[$app_home],
    environment => ["RAILS_ENV=${rails_env}", "DB_PASSWORD='${db_password}'"],
  }

}