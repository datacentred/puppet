# Configures the master git repository on the puppet master.
# - Creates user and group accounts
# - Installs private keys and trusted hosts to access Github
# - Installs the repository from GitHub
# - Installs a list of authorized keys to allow user access
# The repository can be accessed via
# - git@hostname:puppet.git
class dc_puppetmaster::git::config {

  # We need a user and group for all users to login as
  # to get to the master copy of the repository
  group { 'git':
    ensure  => present,
  }
  user { 'git':
    ensure      => present,
    gid         => 'git',
    home        => '/home/git',
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
  file { '/home/git/.ssh':
    ensure  => directory,
    require => User['git'],
  }
  file { '/home/git/.ssh/id_rsa':
    ensure  => present,
    mode    => '0400',
    content => template('dc_puppetmaster/id_rsa'),
    require => File['/home/git/.ssh'],
  }
  file { '/home/git/.ssh/id_rsa.pub':
    ensure  => present,
    content => template('dc_puppetmaster/id_rsa.pub'),
    require => File['/home/git/.ssh'],
  }
  file { '/home/git/.ssh/known_hosts':
    ensure  => present,
    content => template('dc_puppetmaster/known_hosts'),
    require => File['/home/git/.ssh'],
  }

  # Clone the puppet repository from GitHub onto the puppet
  # master
  exec { 'puppet_master_clone_git':
    command => 'bash -c "if [ ! -e /home/git/puppet.git ]; then \
                  sudo -u git git clone \
                    git@github.com:datacentred/puppet.git \
                    /home/git/puppet.git; \
                fi"',
    path    => ['/bin', '/usr/bin'],
    require => [File['/home/git/.ssh/id_rsa'], File['/home/git/.ssh/known_hosts']],
  }

  # Setup the users authorized to access the repositiory
  # this is dumb for the moment and we just allow all
  # users, but the eruby template could be extended to do
  # some better checks based on the hiera data
  $users = hiera('users')

  file { '/home/git/.ssh/authorized_keys':
    ensure  => present,
    content => template('dc_puppetmaster/authorized_keys.erb'),
    require => User['git'],
  }

  # Finally keep git shell happy
  file { '/home/git/git-shell-commands':
    ensure  => directory,
    require => User['git'],
  }

}
