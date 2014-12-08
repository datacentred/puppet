# == Class: dc_elasticsearch::elasticsearch_snapshot_pruning
#
# Create a cron job that prunes old snapshots from ceph
#
class dc_elasticsearch::elasticsearch_snapshot_pruning (
  $access_key        = hiera(datacentred_s3_access_key),
  $secret_key        = hiera(datacentred_s3_secret_key),
  $ceph_access_point = hiera(datacentred_ceph_access_point),
  $ceph_bucket       = hiera(dc_elasticsearch::backup_bucket),
) {

  file { 'elasticsearch_snapshot_pruning.py':
    ensure  => file,
    path    => '/usr/local/bin/elasticsearch_snapshot_pruning.py',
    content => template('dc_elasticsearch/elasticsearch_snapshot_pruning.erb'),
    owner   => root,
    group   => root,
    mode    => '0754',
  }

  cron { 'elasticsearch_snapshot_pruning':
    command => '/usr/local/bin/elasticsearch_snapshot_pruning.py',
    user    => root,
    hour    => 3,
    minute  => 0
  }
}