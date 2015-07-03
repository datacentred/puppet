# Class: dc_collectd::agent
#
# Set up collectd to collect a standard set of metrics for a give host
#
# Requires: collectd
#
class dc_collectd::agent {

  # Compile array of interface names.  If it's a bridge or OVS
  # interface then it'll have had the hyphen swapped out for an underscore
  # by Facter.  We need to change that back before we do anything else.
  # Remove any of the Openstack internal interfaces
  $_interfaces = reject(regsubst(regsubst(split($::interfaces, ','), 'br_', 'br-', 'G'), 'ovs_', 'ovs-', 'G'), '^qvo.*|^qvb.*|^tap.*|^qbr.*')

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

  include dc_collectd::agent::iostat

}
