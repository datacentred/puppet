# Class: dc_profile::perf::collectd::agent
#
# Installs agent performance counter collection
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::perf::collectd::agent inherits dc_profile::perf::collectd {

  class { 'dc_collectd::agent': }

  contain 'collectd::agent'

}
