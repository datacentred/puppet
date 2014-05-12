# Class: dc_collectd::agent
#
# Set up collectd to collect a standard set of metrics for a given host
#
# Actions: Configures collectd metrics for a server agent
#
# Requires: collectd
#
class dc_collectd::agent {

  # Compile array of interface names.  If it's a bridge or OVS
  # interface then it'll have had the hyphen swapped out for an underscore
  # by Facter.  We need to change that back before we do anything else.
  $_interfaces = regsubst(regsubst(split($::interfaces, ','), 'br_', 'br-', 'G'), 'ovs_', 'ovs-', 'G')

  class { 'collectd::plugin::load': }

  class { 'collectd::plugin::memory': }
  
  class { 'collectd::plugin::cpu': }

  class { 'collectd::plugin::disk': 
    disks          => ['/^dm/'],
    ignoreselected => true,
  }

  # Get all our mount points into an array
  $mounts_array = split($::mounts, ',')
  class { 'collectd::plugin::df':
    mountpoints => $mounts_array
  }

  class { 'collectd::plugin::interface': 
    interfaces => $_interfaces,
  }

  # Export virtual resource for load and memory
  @@dc_gdash::overview { $::hostname: }

  # Compile array of unique interface-shorthostname combos for export
  # in the format ifname#shorthostname
  $ifhashhost = suffix($_interfaces, "#${::hostname}")

  # Now export virtual resource for network traffic for each
  # interface
  @@dc_gdash::nettraf { $ifhashhost: }

  # If this is defined (currently set as a top-scope variable by Foreman),
  # then configure collectd to gather statistics from SNMP-enabled devices
  if $::snmptargets {
    include dc_collectd::snmp
  }

  include dc_collectd::agent::disks

}
