# == Class: dc_bmc::hp
#
# HP BMC configuration
#
class dc_bmc::hp {

  include ::dc_bmc::hp::install
  include ::dc_bmc::hp::user_create
  include ::dc_bmc::hp::user_modify
  include ::dc_bmc::hp::network

  # Changes to the network class may involve an ILO restart so run those last
  Class['dc_bmc::hp::install'] ->
  Class['dc_bmc::hp::user_create'] ->
  Class['dc_bmc::hp::user_modify'] ->
  Class['dc_bmc::hp::network']

}