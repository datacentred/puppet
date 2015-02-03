# Class: dc_profile::hp::blade
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
class dc_ipmi::hp::blade {

  $hpblade_packages = ['hpacucli', 'cciss-vol-status' ]

  package { $hpblade_packages :
    ensure  => installed,
  }

  class { 'hpilo':
    dhcp => true,
  }

}
