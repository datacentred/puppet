# Class: dc_bmc::base
#
# Base IPMI config
#
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_bmc::base {

  # We want to load the kernel modules before installing the ipmi services
  include dc_bmc::modules
  include dc_bmc::install
  include dc_bmc::service
  Class['dc_bmc::modules'] -> Class ['dc_bmc::install'] -> Class['dc_bmc::service']

  # Icinga
  include dc_bmc::icinga
  include dc_icinga::hostgroup_bmc

}
