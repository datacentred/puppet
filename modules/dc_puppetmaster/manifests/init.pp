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

  $puppet_ssl_dir = '/var/lib/puppet/ssl'

  # As this host is under the control of another master initially
  # it will have and old set of certs.  The new CA will not be
  # generated if these exist.  However, on subsequent runs we already
  # have valid CA certificates, so move them out of the way for now
  exec { 'puppet_master_save_certs':
    command => "mv ${puppet_ssl_dir} ${puppet_ssl_dir}.bak",
    path    => '/bin',
    before  => Package['puppetmaster-passenger'],
  }

  # Install the packages
  package { 'puppetmaster-passenger':
    ensure  => present,
  }

  # Okay so if the install did happen we'll have a new CA certificate
  # and can delete the old stuff, otherwise restore the old CA
  exec { 'puppet_master_restore_certs':
    command     => "bash -c 'if [ -e ${puppet_ssl_dir} ]; then \
                      rm -rf ${puppet_ssl_dir}.bak; \
                    else \
                      mv ${puppet_ssl_dir}.bak ${puppet_ssl_dir}; \
                    fi'",
    path        => '/bin',
    require     => Package['puppetmaster-passenger'],
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
