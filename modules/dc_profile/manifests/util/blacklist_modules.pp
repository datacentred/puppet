# Class: dc_profile::util::blacklist_modules
#
# Manage kernel modules
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::util::blacklist_modules (
  $modules = [],
){

  ensure_resource( 'kmod::install', $modules )

}
