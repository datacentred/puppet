class dc_profile::hpilo {

  class { 'hpilo':
    dhcp        => true,
  }
}

