# Class: dc_profile::perf::collectd
#
# Installs collectd and graphite exporter
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

  class { '::collectd':
    purge        => true,
    recurse      => true,
    purge_config => true,
  }

  class { 'collectd::plugin::write_graphite':
    graphitehost => hiera('graphite_server'),
    storerates   => false,
  }

  contain collectd

}
