# Class: dc_role::graphite_ssd
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
class dc_role::graphite_ssd {

  class { 'dc_profile::perf::graphite':
    graphite_db_host => $::hostname,
    new_ssd_config   => true,
    cname            => false,
  }
 #contain dc_profile::perf::gdash
 #contain dc_profile::perf::collectd::poller
 #contain dc_profile::perf::network_weathermap
 #contain dc_profile::net::phpipam
 contain dc_profile::db::coredb_mysql
 contain dc_role::generic

}
