# Class: dc_profile::util::packages
#
# Common packages to be installed on all systems
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::util::packages (
  Array $base_packages = undef,
){

  ensure_packages($base_packages)

}
