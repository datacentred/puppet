class dc_profile::ilo {

  class { 'hpilo':
    dhcp        => true,
  }
}

