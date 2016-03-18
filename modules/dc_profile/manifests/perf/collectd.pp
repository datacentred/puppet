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

  include ::collectd::plugin::write_graphite

}
