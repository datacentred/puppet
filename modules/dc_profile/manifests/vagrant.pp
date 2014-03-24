# Class: dc_profile
#
# Vagrant base image, all vagrant hosts receive these bits
# No logging and other centralised stuff
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::vagrant {

  contain dc_profile::editors::vim
  contain dc_profile::net::hosts
  contain dc_profile::net::ntpgeneric
  contain dc_profile::puppet::puppet
  contain dc_profile::util::external_facts

}
