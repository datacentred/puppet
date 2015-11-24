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

  ensure_packages('sysstat')

  class { '::collectd':
    # Convert the hostname into Graphite friendly folder structure
    #   Before: test.box.com
    #   After:  com.box.test
    collectd_hostname => join(reverse(split($::fqdn, '[.]')), '.'),
  }

  include ::collectd::plugin::syslog
  include ::collectd::plugin::load
  include ::collectd::plugin::memory
  include ::collectd::plugin::cpu
  include ::collectd::plugin::write_graphite

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
