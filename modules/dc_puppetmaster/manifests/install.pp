# Install the puppet master package.  You have to be careful here
# wneh instantiating a new puppet master CA... read the comments
class dc_puppetmaster::install {

  $puppet_ssl_dir = '/var/lib/puppet/ssl'

  # As this host is under the control of another master initially
  # it will have and old set of certs.  The new CA will not be
  # generated if these exist.  However, on subsequent runs we already
  # have valid CA certificates, so move them out of the way for now
  exec { 'puppet_master_save_certs':
    command => "bash -c 'if [ -e ${puppet_ssl_dir} ]; then \
                  mv ${puppet_ssl_dir} ${puppet_ssl_dir}.bak; \
                fi'",
    path    => '/bin',
    before  => Package['puppetmaster-passenger'],
  }

  # Set up so we are the CA, the puppet master
  file { '/etc/puppet/puppet.conf':
    ensure  => present,
    content => template('dc_puppetmaster/puppet.conf'),
    owner   => 'root',
    group   => 'root',
    before  => Package['puppetmaster-passenger'],
  }

  # Install the packages.  At this point you are effectively orphaned
  # from the old puppet master
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

  # This plugin is required to talk to the puppetdb backend
  package { 'puppetdb-terminus':
    ensure => present,
  }

}
