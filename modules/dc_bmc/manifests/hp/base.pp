# Class: dc_bmc::hp::base
#
# Class to provision HP utils
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_bmc::hp::base {

  $hpblade_packages = ['hpssacli', 'cciss-vol-status' ]

  package { $hpblade_packages :
    ensure  => installed,
  }

}
