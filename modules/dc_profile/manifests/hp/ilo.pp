#
class dc_profile::hp::ilo {

  class { 'hpilo':
    require => Class['dc_profile::hp::hpsupportrepo'],
    dhcp    => true,
  }

}

