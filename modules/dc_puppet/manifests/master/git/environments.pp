# Class: dc_puppet::master::git::environments
#
# Puppet master dynamic environments
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_puppet::master::git::environments {

  include dc_puppet::master::git::params
  $repo = $dc_puppet::master::git::params::repo
  $home = $dc_puppet::master::git::params::home

  include dc_puppet::params
  $envdir         = $dc_puppet::params::envdir
  $production_env = "${envdir}/production"

  # Set up our environments folder the git user needs then
  # copy over the master production branch only if not already done
  file { $envdir:
    ensure  => directory,
    owner   => 'puppet',
    group   => 'puppet',
    mode    => '0770',
  } ->
  exec { 'dc_puppet::master::config clone production':
    command     => "/usr/bin/git clone ${repo} ${production_env}",
    creates     => $production_env,
    user        => 'git',
    environment => "HOME=${home}"
  } ~>
  exec { 'dc_puppet::master::config submodule init':
    command     => '/usr/bin/git submodule init',
    cwd         => $production_env,
    refreshonly => true,
    user        => 'git',
  } ~>
  exec { 'dc_puppet::master::config submodule update':
    command     => '/usr/bin/git submodule update',
    cwd         => $production_env,
    refreshonly => true,
    user        => 'git',
  }

  # Finally add in the post receive hooks which are responsible
  # for creating new environments when new feature branches are
  # created
  file { "${repo}/hooks/post-receive":
    content => template('dc_puppet/master/git/post-receive.erb'),
    mode    => '0700',
    owner   => 'git',
    group   => 'git',
  }

}
