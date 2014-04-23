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

  class{'ruby::dev':} ->

  package { 'libmariadbclient-dev' :
    ensure => present,
  } ->

  rbenv::gem { 'unicorn':
    user => $user,
    ruby => $ruby,
  } ->

  exec { 'bundle install --deployment':
    command     => "${bundler} install --deployment",
    cwd         => $app_home,
    group       => $group,
    user        => $user,
    timeout     => 600,
    tries       => 3,
  } ->

  exec { "rbenv::rehash for unicorn ${user} ${ruby}":
    command     => "rbenv rehash && rm -f ${home}/.rbenv/.rehash",
    user        => $user,
    group       => $group,
    cwd         => $home,
    environment => [ "HOME=${home}" ],
    path        => [ "${home}/.rbenv/shims", "${home}/.rbenv/bin", '/bin', '/usr/bin' ],
    logoutput   => 'on_failure',
  } ->

  exec { "rbenv::init ${user} ${ruby}":
    command     => '/bin/bash -c \'eval "$(rbenv init -)"\'',
    user        => $user,
    group       => $group,
    cwd         => $home,
    environment => [ "HOME=${home}" ],
    path        => [ "${home}/.rbenv/shims", "${home}/.rbenv/bin", '/bin', '/usr/bin' ],
    logoutput   => 'on_failure',
  } ->

  # Hack to make rbenv rebuild shims
  exec { 'force shims':
    command  => '/bin/bash --login -c "echo"',
    user     => $user,
    group    => $group,
  }

}