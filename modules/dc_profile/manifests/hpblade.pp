# Class to provision HP blades and modify
# chassis information via the ILO
class dc_profile::hpblade {

  package { ['hpacucli', 'cciss-vol-status' ]:
    ensure  => installed,
  }

  class { 'hpilo':
    dhcp => true,
  }

}

