# Installs the ENC bits necessary for puppet to refer to foreman
# rather than use the local site.pp
class dc_profile::puppet_master_foreman {

  class { '::foreman::puppetmaster':
    foreman_url => 'foreman.sal01.datacentred.co.uk',
  }

  file { '/etc/puppet/manifests/site.pp':
    ensure => absent,
  }

}

