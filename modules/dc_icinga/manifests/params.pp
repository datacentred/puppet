# Class:
#
# Implments common parameters shared beween the various
# dc_icinga classes.  Don't include manually
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_icinga::params {

  # Target path for icinga config files
  $cfg_path = '/etc/icinga'

  # Target path for nagios definition files
  $obj_path = '/etc/icinga/objects'

}

