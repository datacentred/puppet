# Class: dc_rails::environment
#
# Build the Rails app environment
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
class dc_rails::environment(
  $home = undef,
  $user = undef,
  $group = undef,
  $ruby = undef,
  $bundler = undef,
  $app_home = undef,
) {

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

  exec { 'rbenv-init':
    command     => "/bin/bash -c 'eval \"$(rbenv init -)\"'",
    cwd         => $app_home,
    group       => $group,
    user        => $user,
  }
}