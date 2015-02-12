# Class: dc_bmc::hp::ilo
#
# Base ILO config
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
class dc_bmc::hp::ilo {

  # Changes to the network class may involve an ILO restart so run those last
  include dc_bmc::hp::base
  include dc_bmc::hp::network
  include dc_bmc::hp::users
  Class['dc_bmc::hp::base'] -> Class ['dc_bmc::hp::users'] -> Class['dc_bmc::hp::network']

}
