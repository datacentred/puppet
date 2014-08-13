# Class: dc_profile::util::mdadm
#
# Set mdadm to boot degraded raid arrays
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::util::mdadm {

  if $::software_raid != undef {
    include dc_mdadm
  }

}
