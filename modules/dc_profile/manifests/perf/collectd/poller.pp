# Class: dc_profile::perf::collectd::poller
#
# Installs the remote device poller for collectd
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::perf::collectd::poller inherits dc_profile::perf::collectd {

  include dc_collectd::poller
  contain dc_collectd::poller

  # Poll SNMP targets
  $snmp_targets = hiera_hash('snmp_targets')
  create_resources('dc_collectd::poller::snmp_target', $snmp_targets)

}
