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

  # Git user's home directory
  $home   = '/home/git'

  # Location of the datacentred puppet mirror
  $repo   = "${home}/puppet.git"

  # Remote backup on github
  $remote = 'git@github.com:datacentred/puppet.git'

}
