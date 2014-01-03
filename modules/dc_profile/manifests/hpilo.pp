class dc_profile::hpilo {

  include stdlib
  $nameservers = values(hiera(nameservers))

  class { 'hpilo':
    shared      => false,
    dhcp        => true,
    dns         => $nameservers[0],
    ilouser     => 'admin',
    ilouserpass => 'password',
    autoip      => false,
  }
}

