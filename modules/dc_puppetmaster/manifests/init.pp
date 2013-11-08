# Class: dc_puppetmaster
#
# DataCentred's take on a puppet master, done simply
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
#   class { 'dc_puppetmaster':
#   }
#
class dc_puppetmaster {

  # Save the old agent certificates that have been signed by
  # the master master.  These must be moved out of the way
  # so that the puppetmaster-passenger deb creates a new
  # CA certificate for apache SSL
  exec { 'puppet_master_save_agent_certs':
    command => 'mv /var/lib/puppet/ssl /var/lib/puppet/ssl.orig',
    path    => '/bin',
    before  => Package['puppetmaster-passenger'],
  }

  # Install the packages
  package { 'puppetmaster-passenger':
    ensure  => present,
  }

  # If the puppetmaster-passenger package was installed
  # then copy the new CA certificates into the agent
  # certificates folder, delete the new master certificates
  # and move the agent certificates back into place
  exec { 'puppet_master_install_master_ca':
    command     => 'cp -a /var/lib/puppet/ssl/ca /var/lib/puppet/ssl.orig',
    path        => '/bin',
    subscribe   => Package['puppetmaster-passenger'],
    refreshonly => true,
  } ~>
  exec { 'puppet_master_delete_master_certs':
    command     => 'rm -rf /var/lib/puppet/ssl',
    path        => '/bin',
    refreshonly => true,
  }

  # The initial move is unconditional as we don't know if
  # the install will happen or not, so we make the move
  # back unconditional too, but only after the install and
  # delete steps if executed
  exec { 'puppet_master_restore_agent_certs':
    command     => 'mv /var/lib/puppet/ssl.orig /var/lib/puppet/ssl',
    path        => '/bin',
    require     => Exec['puppet_master_delete_master_certs'],
  }

  # Seems to collapse due to not being able to chmod
  # /var/lib/puppet/reports to 755, being owned by
  # root.  Maybe a bit agressive with the recursion
  # but what the hell, we're on a tight budget

  file { '/var/lib/puppet/reports':
    ensure  => directory,
    owner   => 'puppet',
    group   => 'puppet',
    recurse => true,
    require => Package['puppetmaster-passenger'],
  }

}
