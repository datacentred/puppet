# Class: dc_role::graphite
#
# Realtime graph plotting role
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::graphite {

  contain dc_profile::perf::graphite
  contain dc_profile::perf::gdash

}
