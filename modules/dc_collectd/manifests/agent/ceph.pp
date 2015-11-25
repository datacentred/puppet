# == Class: dc_collectd::agent::ceph
#
class dc_collectd::agent::ceph(
  $ceph_cluster_name,
  $ceph_test_pool,
) {

  class { 'collectd::plugin::python':
    modulepaths => ['/usr/lib/collectd/ceph'],
    modules     => {
      'ceph_pool_plugin'    => {
        'script_source' => 'puppet:///modules/dc_collectd/ceph/ceph_pool_plugin.py',
        'config'        => {
          'Verbose'  => true,
          'Cluster'  => $ceph_cluster_name,
          'Interval' => 60,
          'TestPool' => $ceph_test_pool,
        },
      },
      'ceph_osd_plugin'     => {
        'script_source' => 'puppet:///modules/dc_collectd/ceph/ceph_osd_plugin.py',
        'config'        => {
          'Verbose'  => true,
          'Cluster'  => $ceph_cluster_name,
          'Interval' => 60,
          'TestPool' => $ceph_test_pool,
        },
      },
      'ceph_pg_plugin'      => {
        'script_source' => 'puppet:///modules/dc_collectd/ceph/ceph_pg_plugin.py',
        'config'        => {
          'Verbose'  => true,
          'Cluster'  => $ceph_cluster_name,
          'Interval' => 60,
          'TestPool' => $ceph_test_pool,
        },
      },
      'ceph_latency_plugin' => {
        'script_source' => 'puppet:///modules/dc_collectd/ceph/ceph_latency_plugin.py',
        'config'        => {
          'Verbose'  => true,
          'Cluster'  => $ceph_cluster_name,
          'Interval' => 60,
          'TestPool' => $ceph_test_pool,
        },
      },
      'ceph_monitor_plugin' => {
        'script_source' => 'puppet:///modules/dc_collectd/ceph/ceph_monitor_plugin.py',
        'config'        => {
          'Verbose'  => true,
          'Cluster'  => $ceph_cluster_name,
          'Interval' => 60,
          'TestPool' => $ceph_test_pool,
        },
      },
      'ceph_iops_plugin'    => {
        'script_source' => 'puppet:///modules/dc_collectd/ceph/ceph_iops_plugin.py',
        'config'        => {
          'Verbose'  => true,
          'Cluster'  => $ceph_cluster_name,
          'Interval' => 60,
          'TestPool' => $ceph_test_pool,
        },
      },
    },
    logtraces   => true,
    interactive => false,
  }

}
