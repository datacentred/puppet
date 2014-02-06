# Class to provision HP blades and modify
# chassis information via the ILO
class dc_profile::hpblade {

  include dc_profile::hpsupportrepo

  package { ['hpacucli', 'cciss-vol-status' ]:
    ensure  => installed,
    require => Dc_repos::Virtual::Repo['local_hpsupport_mirror'],
  }

  class { 'hpilo':
    dhcp => true,
    require => Dc_repos::Virtual::Repo['local_hpsupport_mirror'],
  }

}

