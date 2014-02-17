# Class: dc_puppet::agent
#
# Puppet agent manifest
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_puppet::agent {

  contain dc_puppet::agent::install
  contain dc_puppet::agent::config
  contain dc_puppet::agent::service

  Class['dc_puppet::agent::install'] ->
  Class['dc_puppet::agent::config'] ->
  Class['dc_puppet::agent::service']

}
