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
  contain dc_profile::perf::collectd::poller
  contain dc_profile::perf::network_weathermap

}
