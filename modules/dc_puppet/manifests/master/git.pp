# Class: dc_puppet::master::git
#
# Git manifest
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_puppet::master::git (
  $id_rsa,
  $id_rsa_pub,
) {

  contain dc_puppet::master::git::install
  contain dc_puppet::master::git::config
  contain dc_puppet::master::git::environments

  Class['dc_puppet::master::git::install'] ->
  Class['dc_puppet::master::git::config'] ->
  Class['dc_puppet::master::git::environments']

}
