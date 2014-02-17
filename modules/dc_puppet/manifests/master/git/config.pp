# Class: dc_puppet::master::git::config
#
# Configures the master git repository on the puppet master.
# - Creates user and group accounts
# - Installs private keys and trusted hosts to access Github
# - Installs the repository from GitHub
# - Installs a list of authorized keys to allow user access
# The repository can be accessed via
# - git@hostname:puppet.git
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_puppet::master::git::config {

  include dc_puppet::master::git::params
  $home   = $dc_puppet::master::git::params::home
  $repo   = $dc_puppet::master::git::params::repo
  $remote = $dc_puppet::master::git::params::remote

  # We need a user and group for all users to login as
  # to get to the master copy of the repository
  group { 'git':
    ensure  => present,
  }

  # Become a member of the puppet group so we have write
  # access to the environments
  user { 'git':
    ensure      => present,
    gid         => 'git',
    groups      => 'puppet',
    home        => $home,
    managehome  => true,
    shell       => '/usr/bin/git-shell',
    require     => Group['git'],
  }

  # Defaults for all file declarations
  File {
    owner   => 'git',
    group   => 'git',
    mode    => '0644',
  }

  # Install the ssh keys to grant access to the GitHub
  # backup servers
  file { "${home}/.ssh":
    ensure  => directory,
    require => User['git'],
  }

  file { "${home}/.ssh/id_rsa":
    ensure  => present,
    mode    => '0400',
    content => template('dc_puppet/master/git/id_rsa'),
    require => File["${home}/.ssh"],
  }

  file { "${home}/.ssh/id_rsa.pub":
    ensure  => present,
    content => template('dc_puppet/master/git/id_rsa.pub'),
    require => File["${home}/.ssh"],
  }

  file { "${home}/.ssh/known_hosts":
    ensure  => present,
    content => template('dc_puppet/master/git/known_hosts'),
    require => File["${home}/.ssh"],
  }

  # Clone the puppet repository from GitHub onto the puppet
  # master
  exec { 'puppet_master_clone_git':
    command     => "/usr/bin/git clone --bare ${remote} ${repo}",
    user        => 'git',
    creates     => $repo,
    timeout     => 3600,
    require     => [
      File["${home}/.ssh/id_rsa"],
      File["${home}/.ssh/known_hosts"]
    ],
  }

  # Authorize admins to use the git account
  dc_users::group_account_authorize { 'admins@git': }

  # Finally keep git shell happy
  file { "${home}/git-shell-commands":
    ensure  => directory,
    require => User['git'],
  }

}
