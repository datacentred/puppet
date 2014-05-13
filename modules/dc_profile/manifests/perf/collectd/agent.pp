# Class: dc_profile::perf::collectd::agent
#
# Installs the collectd host (agent) plugins and configures them to export data
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

  include dc_collectd::agent
  contain dc_collectd::agent

}
