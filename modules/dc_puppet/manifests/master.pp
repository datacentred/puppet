# Class: dc_puppet::master
#
# Puppet master manifest
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_puppet::master {

  contain dc_puppet::master::install
  contain dc_puppet::master::config

  Class['dc_puppet::master::install'] ->
  Class['dc_puppet::master::config']

}
