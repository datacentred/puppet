# == Class: dc_elasticsearch::params
#
# Pull some variables in from hiera so they're accessible everywhere!
#
class dc_elasticsearch::params (
  $elasticsearch_version,
  $backup_name,
  $backup_bucket,
  $logstash_server,
  $ceph_access_key,
  $ceph_private_key,
  $ceph_access_point,
  $elasticsearch_data_dir,
  $total_retention,
  $ssd_tier_retention,
  $backup_node = false,
) {}
