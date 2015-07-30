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
    source  => 'puppet:///modules/dc_collectd/ceph',
    recurse => true,
  }

  collectd::plugin::python { 'ceph_pool':
    modulepath    => '/usr/lib/collectd/ceph',
    module        => 'ceph_pool_plugin',
    script_source => 'puppet:///modules/dc_collectd/ceph/ceph_pool_plugin.py',
    config        => {
      'Verbose'  => true,
      'Cluster'  => $ceph_cluster_name,
      'Interval' => 60,
      'TestPool' => $ceph_test_pool,
    },
  }

  collectd::plugin::python { 'ceph_osd':
    modulepath    => '/usr/lib/collectd/ceph',
    module        => 'ceph_osd_plugin',
    script_source => 'puppet:///modules/dc_collectd/ceph/ceph_osd_plugin.py',
    config        => {
      'Verbose'  => true,
      'Cluster'  => $ceph_cluster_name,
      'Interval' => 60,
      'TestPool' => $ceph_test_pool,
    },
  }

  collectd::plugin::python { 'ceph_monitor':
    modulepath    => '/usr/lib/collectd/ceph',
    module        => 'ceph_monitor_plugin',
    script_source => 'puppet:///modules/dc_collectd/ceph/ceph_monitor_plugin.py',
    config        => {
      'Verbose'  => true,
      'Cluster'  => $ceph_cluster_name,
      'Interval' => 60,
      'TestPool' => $ceph_test_pool,
    },
  }

  collectd::plugin::python { 'ceph_pg':
    modulepath    => '/usr/lib/collectd/ceph',
    module        => 'ceph_pg_plugin',
    script_source => 'puppet:///modules/dc_collectd/ceph/ceph_pg_plugin.py',
    config        => {
      'Verbose'  => true,
      'Cluster'  => $ceph_cluster_name,
      'Interval' => 60,
      'TestPool' => $ceph_test_pool,
    },
  }

  collectd::plugin::python { 'ceph_latency':
    modulepath    => '/usr/lib/collectd/ceph',
    module        => 'ceph_latency_plugin',
    script_source => 'puppet:///modules/dc_collectd/ceph/ceph_latency_plugin.py',
    config        => {
      'Verbose'  => true,
      'Cluster'  => $ceph_cluster_name,
      'Interval' => 60,
      'TestPool' => $ceph_test_pool,
    },
  }

  collectd::plugin::python { 'ceph_iops':
    modulepath    => '/usr/lib/collectd/ceph',
    module        => 'ceph_iops_plugin',
    script_source => 'puppet:///modules/dc_collectd/ceph/ceph_iops_plugin.py',
    config        => {
      'Verbose'  => true,
      'Cluster'  => $ceph_cluster_name,
      'Interval' => 60,
      'TestPool' => $ceph_test_pool,
    },
  }

}
