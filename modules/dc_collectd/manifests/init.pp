# Class: dc_collectd
#
# Set up collectd to collect a standard set of metrics for a give host
#
# Actions: Hooks into dc_gdash for dynamic dashboard graph generation
#
# Requires: collectd, dc_gdash
#
# Sample Usage: dc_gdash::nettraf { 'eth0#gdash': }
#
# Class: dc_collectd
#
class dc_collectd (
  $graphite_server = '',
  $_interfaces = split($::interfaces, ','),
) {

  class { '::collectd':
    purge        => true,
    recurse      => true,
    purge_config => true,
  }

  class { 'collectd::plugin::load': }

  class { 'collectd::plugin::memory': }

  class { 'collectd::plugin::disk': 
    disks          => ['/^dm/'],
    ignoreselected => true,
  }

  class { 'collectd::plugin::interface': 
    interfaces => $_interfaces,
  }

  # Configure collectd to send its output to carbon
  class { 'collectd::plugin::write_graphite':
    graphitehost => $graphite_server,
  }

  # Export virtual resource for load and memory
  @@dc_gdash::hostgraph { $::hostname: }

  # Compile array of unique interface-shorthostname combos for export
  # in the format ifname#shorthostname
  $ifhashhost = suffix($interfaces, "#${::hostname}")

  # Now export virtual resource for network traffic for each
  # interface
  @@dc_gdash::nettraf { $ifhashhost: }

  # If this is defined (currently set as a top-scope variable by Foreman),
  # then configure collectd to gather statistics from SNMP-enabled devices
  if $::snmptargets {
    include dc_collectd::snmp
  }

  contain 'collectd'

}
