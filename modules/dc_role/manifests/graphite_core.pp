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
  contain dc_profile::perf::collectd::poller
  contain dc_profile::perf::network_weathermap
  contain dc_profile::perf::grafana
  contain dc_profile::db::duplicity_mariadb
  include dc_collectd::agent::openstack

}
