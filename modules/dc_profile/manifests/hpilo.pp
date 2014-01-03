class dc_profile::hpilo {

  include stdlib

  class { 'hpilo':
    dhcp        => true,
  }
}

