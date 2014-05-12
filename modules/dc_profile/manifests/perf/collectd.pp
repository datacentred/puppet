# Class: dc_profile::perf::collectd
#
# Installs collectd
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

  # Configure collectd to send its output to carbon
  class { 'collectd::plugin::write_graphite':
    graphitehost => hiera('graphite_server'),
  }

  contain 'collectd'
  contain 'collectd::plugin::write_graphite'

}
