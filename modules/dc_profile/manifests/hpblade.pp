class dc_profile::hpblade {

  include dc_profile::hpsupportrepo

  package { ['hpacucli', 'cciss-vol-status']:
    ensure  => installed,
  }

}

