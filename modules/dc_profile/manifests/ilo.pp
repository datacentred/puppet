class dc_profile::ilo {

  class { 'hpilo':
    require => Class['dc_profile::hpsupportrepo'],
    dhcp    => true,
  }
}

