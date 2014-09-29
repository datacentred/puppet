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

  class { '::collectd':
    # Convert the hostname into Graphite friendly folder structure
    #   Before: test.box.com
    #   After:  com.box.test
    hostname      => join(reverse(split($::fqdn, '[.]')), '.'),
    fqdnlookup    => false,
    purge         => true,
    recurse       => true,
    purge_config  => true,
  }

  class { 'collectd::plugin::syslog':
    log_level => 'error',
  }

  class { 'collectd::plugin::write_graphite':
    graphitehost      => hiera('graphite_server'),
    graphiteprefix    => 'collectd.',
    escapecharacter   => '.',
    storerates        => false,
    separateinstances => true,
    protocol          => 'tcp',
  }

}
