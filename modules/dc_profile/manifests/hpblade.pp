class dc_profile::hpblade {

  include hpilo
  include dc_profile::hpsupportrepo

  package { ['hpacucli', 'cciss-vol-status', 'hponcfg' ]:
    ensure  => installed,
    require => Dc_repos::Virtual::Repo['local_hpsupport_mirror']
  }

  class { 'hpilo':
    require     => Package['hponcfg'],
    dhcp        => true,
    dns         => hiera(dnsmaster),
    ilouser     => 'admin',
    ilouserpass => 'password',
    autoip      => false,
  }
}

