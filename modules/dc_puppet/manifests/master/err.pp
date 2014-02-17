# Class: dc_puppet::master::err
#
# Errbot manifest
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_puppet::master::err {

  contain dc_puppet::master::err::install
  contain dc_puppet::master::err::config
  contain dc_puppet::master::err::service

  Class['dc_puppet::master::err::install'] ->
  Class['dc_puppet::master::err::config'] ~>
  Class['dc_puppet::master::err::service']

}
