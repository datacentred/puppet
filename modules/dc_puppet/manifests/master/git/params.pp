# Class: dc_puppet::master::git::params
#
# Git parameters
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_puppet::master::git::params {
  $home   = '/home/git'
  $repo   = "${home}/puppet.git"
  $remote = 'git@github.com:datacentred/puppet.git'
}
