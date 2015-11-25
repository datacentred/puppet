# == Class: dc_collectd::agent::ceph
#
class dc_collectd::agent::ceph(
  $ceph_cluster_name,
  $ceph_test_pool,
) {

  file { '/usr/lib/collectd/ceph' :
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    require => Package['collectd'],
  }

  Collectd::Plugin::Python::Module {
    modulepath => '/usr/lib/collectd/ceph',
    require    => File['/usr/lib/collectd/ceph'],
    config        => {
      'Verbose'  => true,
      'Cluster'  => $ceph_cluster_name,
      'Interval' => 60,
      'TestPool' => $ceph_test_pool,
    },
  }

  collectd::plugin::python::module { 'ceph_pool':
    module        => 'ceph_pool_plugin',
    script_source => 'puppet:///modules/dc_collectd/ceph/ceph_pool_plugin.py',
  }

  collectd::plugin::python::module { 'ceph_osd':
    module        => 'ceph_osd_plugin',
    script_source => 'puppet:///modules/dc_collectd/ceph/ceph_osd_plugin.py',
  }

  collectd::plugin::python::module { 'ceph_monitor':
    module        => 'ceph_monitor_plugin',
    script_source => 'puppet:///modules/dc_collectd/ceph/ceph_monitor_plugin.py',
  }

  collectd::plugin::python::module { 'ceph_pg':
    module        => 'ceph_pg_plugin',
    script_source => 'puppet:///modules/dc_collectd/ceph/ceph_pg_plugin.py',
  }

  collectd::plugin::python::module { 'ceph_latency':
    module        => 'ceph_latency_plugin',
    script_source => 'puppet:///modules/dc_collectd/ceph/ceph_latency_plugin.py',
  }

  collectd::plugin::python::module { 'ceph_iops':
    module        => 'ceph_iops_plugin',
    script_source => 'puppet:///modules/dc_collectd/ceph/ceph_iops_plugin.py',
  }

}
