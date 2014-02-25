# Class: dc_profile::perf::collectd
#
# Installs performance counter collection
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::perf::collectd {

  class { 'dc_collectd':
    graphite_server => hiera(graphite_server),
  }

}
