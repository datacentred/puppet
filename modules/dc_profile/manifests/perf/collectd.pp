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

  if $::fqdn == 'graphite0.sal01.datacentred.co.uk' {

    class { '::collectd':
      # Convert the hostname into Graphite friendly folder structure
      #   Before: test.box.com
      #   After:  com.box.test
      hostname      => join(reverse(split($::fqdn, '[.]')), '.'),
      purge         => true,
      recurse       => true,
      purge_config  => true,
    }

    class { 'collectd::plugin::write_graphite':
      graphitehost      => hiera('graphite_server'),
      graphiteprefix    => 'rob.',
      escapecharacter   => '.',
      storerates        => false,
      separateinstances => true,
    }

  } else {

    class { '::collectd':
      purge         => true,
      recurse       => true,
      purge_config  => true,
    }

    class { 'collectd::plugin::write_graphite':
      graphitehost => hiera('graphite_server'),
      storerates   => false,
    }

  }

  contain collectd

}
