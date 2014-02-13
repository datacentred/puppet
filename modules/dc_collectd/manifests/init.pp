#
# Class: dc_collectd
#
# Install and configure collectd with a standard set of plugins.
#
class dc_collectd (
  $graphite_server = '',
  $interfaces = split($::interfaces, ','),
) {

  realize (Dc_repos::Repo['local_collectd_mirror'])

  class { '::collectd':
    require      => Dc_repos::Repo['local_collectd_mirror'],
    purge        => true,
    recurse      => true,
    purge_config => true,
  }

  class { 'collectd::plugin::load': }

  class { 'collectd::plugin::memory': }

  class { 'collectd::plugin::interface': 
    interfaces => $interfaces,
  }

  # Configure collectd to send its output to carbon
  class { 'collectd::plugin::write_graphite':
    graphitehost => $graphite_server,
  }

  @@dc_gdash::hostgraph { $::hostname: }

  if $::snmptargets {
    include dc_collectd::snmp
  }

  contain 'collectd'

}
