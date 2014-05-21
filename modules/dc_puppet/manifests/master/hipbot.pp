# Class: dc_puppet::master::hipbot
#
# Hipbot manifest
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_puppet::master::hipbot {

  contain dc_puppet::master::hipbot::install
  contain dc_puppet::master::hipbot::config
  contain dc_puppet::master::hipbot::service

  Class['dc_puppet::master::hipbot::install'] ->
  Class['dc_puppet::master::hipbot::config'] ~>
  Class['dc_puppet::master::hipbot::service']

}
