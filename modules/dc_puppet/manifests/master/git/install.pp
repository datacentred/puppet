# Class: dc_puppet::master::git::install
#
# Puppet master git installation
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_puppet::master::git::install {

  package { 'git':
    ensure  => present,
  }

}
