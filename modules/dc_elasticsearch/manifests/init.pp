# Class: dc_elasticsearch
#
# Configures elasticsearch and runs one instance
#
# Parameters:
#
# Actions:
#
# Requires: puppet-elasticsearch
#
# Sample Usage:
#
class dc_elasticsearch (
  $backup_name,
  $backup_bucket,
  $ceph_access_point,
  $ceph_access_key,
  $ceph_private_key,
  $total_retention,
  $backup_node = false,
  $instances = {},
  $plugins = {},
) {

  include ::dc_elasticsearch::install
  include ::dc_elasticsearch::configure
  include ::dc_elasticsearch::pruning
  include ::dc_elasticsearch::snapshot
  include ::dc_elasticsearch::template

  Class['::dc_elasticsearch::install'] ->
  Class['::dc_elasticsearch::configure'] ->
  Class['::dc_elasticsearch::pruning'] ->
  Class['::dc_elasticsearch::snapshot'] ->
  Class['::dc_elasticsearch::template']

}
