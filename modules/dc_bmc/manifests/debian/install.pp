# == Class: dc_bmc::debian::install
#
# Ensures that ipmitool and utils are installed
#
class dc_bmc::debian::install {

  $packages = [
    'freeipmi-tools',
    'ipmitool',
  ]

  ensure_packages($packages)

}
