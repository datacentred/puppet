# == Class: dc_elasticsearch::params
#
# Pull some variables in from hiera so they're accessible everywhere!
#
class dc_elasticsearch::params (
  $backup_name,
  $backup_bucket,
  $logstash_server,
  $ceph_access_key,
  $ceph_private_key,
  $ceph_access_point,
  $elasticsearch_data_dir,
  $es_aws_plugin_version,
) {}