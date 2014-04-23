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
  $user = hiera(rails::user::name),
  $password = hiera(rails::user::password),
  $group = hiera(rails::user::name),
  $secret_key_base = hiera(rails::server::secret_key),
  $db_password = hiera(dc_mariadb::maria_root_pw),
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

  class { 'webserver':
    proxy    => "unix://${rundir}unicorn.sock",
    app_name => $app_name,
    app_url  => $app_url,
    ssl_cert => $ssl_cert,
    ssl_key  => $ssl_key,
  }

  user { $user :
    ensure     => present,
    groups     => 'sudo',
    shell      => '/bin/bash',
    managehome => true,
    home       => $home,
    password   => $password,
  } ->

  class { 'files':
    home      => $home,
    logdir    => $logdir,
    log_base  => $log_base,
    rundir    => $rundir,
    run_base  => $run_base,
    rails_env => $rails_env,
    app_home  => $app_home,
    user      => $user,
    group     => $group,
  } ->

  vcsrepo { $app_home:
    ensure   => present,
    provider => git,
    source   => $app_repo,
    user     => $user,
    revision => 'master',
  } ->

  class { 'environment':
    home     => $home,
    user     => $user,
    group    => $group,
    ruby     => $ruby,
    bundler  => $bundler,
    app_home => $app_home,
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
    subscribe        =>  [
        Class['environment'],
        Class['webserver'],
        Vcsrepo[$app_home],
      ],
  } ->

  class { 'db':
    db_password => $db_password,
    bundler     => $bundler,
    app_home    => $app_home,
    user        => $user,
    group       => $group,
    rails_env   => $rails_env,
  }

}