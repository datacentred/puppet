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

  # Set up our environments folder the git user needs then
  # copy over the master production branch only if not already done
  file { '/etc/puppet/environments':
    ensure => directory,
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0770',
  } ->
  exec { 'dc_puppet::master::config clone production':
    command     => "/usr/bin/git clone ${repo} /etc/puppet/environments/production",
    creates     => '/etc/puppet/environments/production',
    user        => 'git',
    environment => "HOME=${home}"
  } ~>
  exec { 'dc_puppet::master::config submodule init':
    command     => '/usr/bin/git submodule init',
    cwd         => '/etc/puppet/environments/production',
    refreshonly => true,
    user        => 'git',
  } ~>
  exec { 'dc_puppet::master::config submodule update':
    command     => '/usr/bin/git submodule update',
    cwd         => '/etc/puppet/environments/production',
    refreshonly => true,
    user        => 'git',
    timeout     => 0,
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

  file { "${repo}/hooks/pre-receive":
    content => template('dc_puppet/master/git/pre-receive.erb'),
    mode    => '0700',
    owner   => 'git',
    group   => 'git',
  }

}
