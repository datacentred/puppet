# Generic role all servers possess
class dc_role::generic {

  # Force the base repositories to install before the
  # rest of the software, prevents littering dependencies
  # across the code base

  stage { 'repos':
    before => Stage['main'],
  }

  class { 'dc_profile::rootpw':
    stage => 'repos',
  }

  class { 'dc_profile::baserepos':
    stage => 'repos',
  }

  contain dc_profile::base

}
