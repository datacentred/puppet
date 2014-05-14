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
    purge        => true,
    recurse      => true,
    purge_config => true,
  }

  if $::fqdn == 'graphite0.sal01.datacentred.co.uk' {
    class { 'collectd::plugin::write_graphite':
      graphitehost      => hiera('graphite_server'),
      graphiteprefix    => 'rob.',
      escapecharacter   => '.',
      storerates        => false,
      separateinstances => true,
    }
  } else {
    class { 'collectd::plugin::write_graphite':
      graphitehost => hiera('graphite_server'),
      storerates   => false,
    }
  }

  contain collectd

}
