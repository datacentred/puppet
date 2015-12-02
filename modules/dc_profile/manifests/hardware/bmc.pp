# == Class: dc_profile::hardware::bmc
#
class dc_profile::hardware::bmc {

  include dc_bmc
  include dc_foreman::update_bmc

}
