# == Class: dc_bmc::hp::install
#
# Class to provision HP packages
#
class dc_bmc::hp::install {

  include ::dc_bmc::hp

  $hpblade_packages = [
    'hpssacli',
    'hponcfg',
    'cciss-vol-status'
  ]

  ensure_packages($hpblade_packages)

}
