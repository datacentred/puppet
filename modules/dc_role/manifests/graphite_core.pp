# Class: dc_role::graphite_core
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
class dc_role::graphite_core {

  contain dc_profile::perf::graphite
  contain dc_profile::perf::gdash

}
