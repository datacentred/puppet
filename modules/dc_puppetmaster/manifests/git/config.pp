# Setup the bits to install git from the central git hub repo.
# This involves the somewhat controvertial installation of
# private keys that correspond to the public key which is in
# GitHub, the known hosts file, which avoids using the even
# more unsafe StrictHostKeyChecking=no :)  Then and only then
# we can clone, and a bare one at that to prevent modifications
class dc_puppetmaster::git::config {

  group { 'git':
    ensure  => present,
  }

  user { 'git':
    ensure      => present,
    gid         => 'git',
    home        => '/home/git',
    managehome  => true,
  }

  File {
    owner   => 'git',
    group   => 'git',
    mode    => '0644',
  }

  file { '/home/git/.ssh':
    ensure  => directory,
  }

  file { '/home/git/.ssh/id_rsa':
    ensure  => present,
    mode    => '0400',
    content => template('dc_puppetmaster/id_rsa'),
  }

  file { '/home/git/.ssh/id_rsa.pub':
    ensure  => present,
    content => template('dc_puppetmaster/id_rsa.pub'),
  }

  file { '/home/git/.ssh/known_hosts':
    ensure  => present,
    content => template('dc_puppetmaster/known_hosts'),
  }

  exec { 'puppet_master_clone_git':
    command => 'bash -c "if [ ! -e /home/git/puppet.git ]; then \
                  sudo -u git git clone --bare \
                    git@github.com:datacentred/puppet.git \
                    /home/git/puppet.git; \
                fi"',
    path    => ['/bin', '/usr/bin'],
  }

  $users = hiera('users')

  file { '/home/git/.ssh/authorized_keys':
    ensure  => present,
    content => template('dc_puppetmaster/authorized_keys.erb'),
  }

#  file { '/etc/puppet/environments':
#    ensure  => directory,
#  }
#
#  exec { 'puppet_master_install_env_production':
#    command => 'bash -c "cd /etc/puppet/environments; \
#                git clone git@github.com:datacentred/puppet.git production; \
#                cd production; \
#                git checkout production; \
#                git submodule init; \
#                git submodule update;"',
#    path    => ['/bin', '/usr/bin'],
#  }

  Group['git'] ~>
  User['git'] ~>
  File['/home/git/.ssh'] ~>
  File['/home/git/.ssh/id_rsa'] ~>
  File['/home/git/.ssh/id_rsa.pub'] ~>
  File['/home/git/.ssh/known_hosts'] ~>
  Exec['puppet_master_clone_git']

}
