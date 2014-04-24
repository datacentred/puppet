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

  class{'ruby::dev':} ->

  class { 'dc_mariadb': } ->

  package { 'libmariadbclient-dev' :
    ensure => present,
  } ->

  rbenv::gem { 'unicorn':
    user => $user,
    ruby => $ruby,
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