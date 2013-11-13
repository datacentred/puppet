# Perform post installation configuration tasks
class dc_puppetmaster::config {

  File {
    owner   => 'puppet',
    group   => 'puppet',
  }

  # Seems to collapse due to not being able to chmod
  # /var/lib/puppet/reports to 755, being owned by
  # root.  Maybe a bit agressive with the recursion
  # but what the hell, we're on a tight budget
  file { '/var/lib/puppet/reports':
    ensure  => directory,
    recurse => true,
  }

  file { '/etc/puppet/environments':
    ensure  => directory,
  }

  exec { 'puppet_master_install_env_production':
    command => 'bash -c "cd /etc/puppet/environments; \
                if [ ! -e production ]; then
                  git clone /home/git/puppet.git production; \
                  cd production; \
                  git checkout production; \
                  git submodule init; \
                  git submodule update; \
                fi"',
    path    => ['/bin', '/usr/bin'],
  }

  File['/etc/puppet/environments'] ~>
  Exec['puppet_master_install_env_production']

}
