# Class: dc_role::generic
#
# Generic role all servers possess
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::generic {

  # Force the base repositories to install before the
  # rest of the software, prevents littering dependencies
  # across the code base

  stage { 'repos':
    before => Stage['main'],
  }

  class { [
    'dc_profile::apt::apt',
    'dc_profile::apt::dpkg',
    'dc_profile::repos',
    'dc_profile::auth::rootpw',
  ]:
    stage => 'repos',
  }

  contain dc_profile

}
