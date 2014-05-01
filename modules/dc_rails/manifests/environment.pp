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

  package { 'libmariadbclient-dev' :
    ensure => present,
  } ->

  rbenv::gem { 'unicorn':
    user   => $user,
    ruby   => $ruby,
    notify => [
      Exec["rbenv::rehash for unicorn ${user} ${ruby}"],
      Exec["rbenv::init ${user} ${ruby}"],
      Exec["force shims ${user} ${ruby}"],
    ]
  } ->

  exec { "rbenv::rehash for unicorn ${user} ${ruby}":
    command     => "rbenv rehash && rm -f ${home}/.rbenv/.rehash",
    user        => $user,
    group       => $group,
    cwd         => $home,
    environment => [ "HOME=${home}" ],
    path        => [ "${home}/.rbenv/shims", "${home}/.rbenv/bin", '/bin', '/usr/bin' ],
    logoutput   => 'on_failure',
    refreshonly => true,
  } ->

  exec { "rbenv::init ${user} ${ruby}":
    command     => '/bin/bash -c \'eval "$(rbenv init -)"\'',
    user        => $user,
    group       => $group,
    cwd         => $home,
    environment => [ "HOME=${home}" ],
    path        => [ "${home}/.rbenv/shims", "${home}/.rbenv/bin", '/bin', '/usr/bin' ],
    logoutput   => 'on_failure',
    refreshonly => true,
  } ->

  # Hack to make rbenv rebuild shims
  exec { "force shims ${user} ${ruby}":
    command  => '/bin/bash --login -c "echo"',
    user     => $user,
    group    => $group,
    refreshonly => true,
  }

}