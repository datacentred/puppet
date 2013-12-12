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

  # Set up our environments folder
  file { '/etc/puppet/environments':
    ensure  => directory,
    mode    => '0777',
  }

  # Copy over the master production branch at least
  # from the repository
  exec { 'puppet_master_install_env_production':
    command => 'bash -c "cd /etc/puppet/environments; \
                if [ ! -e production ]; then
                  git clone /home/git/puppet.git production; \
                  cd production; \
                  git submodule init; \
                  git submodule update; \
                fi"',
    path    => ['/bin', '/usr/bin'],
  }

  # Finally add in the post receive hooks which are responsible
  # for creating new environments when new feature branches are
  # created
  file { '/home/git/puppet.git/hooks/post-receive':
    mode    => '0777',
    content => template('dc_puppetmaster/post-receive.erb'),
  }

  # Install hiera configuration file and notify the apache/
  # passenger service of the change to force a restart
  file { '/etc/puppet/hiera.yaml':
    mode    => '0644',
    content => template('dc_puppetmaster/hiera.yaml'),
  }

  if ! defined(Service['apache2']) {
    service { 'apache2':
      ensure => running,
    }
  }

  # On a foreman node it needs access to the private key to
  # interact with smart proxies over SSL.  It's part of the
  # puppet group so just grant group read privilige
  file { "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem":
    ensure  => file,
    mode    => '0640',
  }

  File['/etc/puppet/hiera.yaml'] ~> Service['apache2']

  File['/etc/puppet/environments'] ~>
  Exec['puppet_master_install_env_production']

}
