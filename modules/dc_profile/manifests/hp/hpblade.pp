# Class: dc_profile::hp::hpblade
#
# Class to provision HP blades and modify
# chassis information via the ILO
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::hp::hpblade {

  package { ['hpacucli', 'cciss-vol-status' ]:
    ensure  => installed,
  }

  package { 'isc-dhcp-client':
    ensure => purged,
  }

  class { 'hpilo':
    dhcp => true,
  }

}
