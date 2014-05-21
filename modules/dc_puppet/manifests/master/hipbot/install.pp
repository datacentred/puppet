# Class: dc_puppet::master::hipbot::install
#
# Hipbot installation
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_puppet::master::hipbot::install {

  include ::dc_puppet::master::hipbot::params

  Package {
    ensure => installed,
  }

  package { $::dc_puppet::master::hipbot::params::debs:
  } ->

  package { $::dc_puppet::master::hipbot::params::pips:
    provider => 'pip',
  }

}
