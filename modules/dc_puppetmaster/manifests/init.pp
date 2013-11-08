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

  exec { 'puppet_master_clean_certs':
    command => 'rm -rf /var/lib/puppet/ssl',
    path    => '/bin',
    before  => Package['puppetmaster-passenger'],
  }

  package { 'puppetmaster-passenger':
    ensure  => present,
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
