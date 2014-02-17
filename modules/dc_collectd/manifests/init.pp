# Class: dc_collectd
#
# Install and configure collectd with a standard set of plugins for monitoring
# load, memory utilisation, and network interface statistics.  Hooks into dc_gdash
# module for dynamic dashboard generation.
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

  # Export virtual resource for load and memory
  @@dc_gdash::hostgraph { $::hostname: }

  # Compile array of unique interface-fqdn combos
  # $hostif becomes ifname-hostname
  $hostif = suffix($interfaces, "_${::hostname}")

  # Export virtual resource for network traffic for each
  # interface
  @@dc_gdash::nettraf { $hostif: }

  # If this is defined (currently set as a top-scope variable by Foreman),
  # then configure collectd to gather statistics from SNMP-enabled devices
  if $::snmptargets {
    include dc_collectd::snmp
  }

  contain 'collectd'

}
