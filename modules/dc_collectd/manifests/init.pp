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
) {

  # Compile array of interface names.  If it's a bridge or OVS
  # interface then it'll have had the hyphen swapped out for an underscore
  # by Facter.  We need to change that back before we do anything else.
  $_interfaces = regsubst(regsubst(split($::interfaces, ','), 'br_', 'br-', 'G'), 'ovs_', 'ovs-', 'G')

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
  $ifhashhost = suffix($_interfaces, "#${::hostname}")

  # Now export virtual resource for network traffic for each
  # interface
  @@dc_gdash::nettraf { $ifhashhost: }

  # For disks we have 3 seperate facts which contain the devices
  # FIXME handle only having one entry in the string )
  # FIXME sort
  $mdarray = split($::software_raid, ',')
  $disksarray = split($::disks, ',')
  $partsarray = split($::partitions, ',')
  #$joinedarray = [ $mdarray, $disksarray, $partsarray ]
  $joinedarray = [ split($::software_raid, ','), split($::disks, ','), split($::partitions, ',') ]
  $diskhashhost = suffix($joinedarray, "#${::hostname}")

  @@dc_gdash_disk_merged_ops { $diskhashhost: }
  @@dc_gdash_disk_octets { $diskhashhost: }
  @@dc_gdash_disk_ops { $diskhashhost: }
  @@dc_gdash_disk_time { $diskhashhost: }

  # If this is defined (currently set as a top-scope variable by Foreman),
  # then configure collectd to gather statistics from SNMP-enabled devices
  if $::snmptargets {
    include dc_collectd::snmp
  }

  contain 'collectd'

}
