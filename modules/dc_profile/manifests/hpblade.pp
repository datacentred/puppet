class dc_profile::hpblade {

  include stdlib
  include dc_profile::hpsupportrepo
  $nameservers = values(hiera(nameservers))

  package { ['hpacucli', 'cciss-vol-status' ]:
    ensure  => installed,
    require => Dc_repos::Virtual::Repo['local_hpsupport_mirror']
  }

  class { 'hpilo':
    shared      => false,
    dhcp        => true,
    dns         => $nameservers[0],
    ilouser     => 'admin',
    ilouserpass => 'password',
    autoip      => false,
  }
}

