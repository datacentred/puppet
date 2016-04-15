# == Class: dc_collectd::agent::default
#
# installs the basic collectd plugins
class dc_collectd::agent::default{

  ensure_packages('sysstat')

  include ::collectd::plugin::syslog
  include ::collectd::plugin::load
  include ::collectd::plugin::memory
  include ::collectd::plugin::cpu
  include ::collectd::plugin::write_graphite
  include ::collectd::plugin::sensors
  include ::dc_collectd::agent::iostat

  class { '::collectd::plugin::disk':
    disks => ['/^dm/'],
  }

  class { '::collectd::plugin::df':
    mountpoints => split($::mounts, ','),
  }

  class { '::collectd::plugin::interface':
    # Interface names returned from Facter need to have the underscores
    # swapped back to hyphens.  We then reject OpenStack-specific interface
    # names, i.ve the OVS-specific plumbing.
    interfaces => reject(regsubst(regsubst(split($::interfaces, ','), 'br_', 'br-', 'G'), 'ovs_', 'ovs-', 'G'), '^qvo.*|^qvb.*|^tap.*|^qbr.*'),
  }

}
