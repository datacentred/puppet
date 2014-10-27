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
class dc_role::graphite_core inherits dc_role {

  contain dc_profile::perf::graphite
  contain dc_profile::perf::gdash
  contain dc_profile::perf::collectd::poller
  contain dc_profile::perf::network_weathermap

}
