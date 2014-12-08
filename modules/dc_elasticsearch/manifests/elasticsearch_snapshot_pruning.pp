# == Class: dc_elasticsearch::elasticsearch_snapshot_pruning
#
# Create a cron job that prunes old snapshots from ceph
#
class dc_elasticsearch::elasticsearch_snapshot_pruning (
  $access_key      = hiera(datacentred_s3_access_key)
  $secret_key      = hiera(datacentred_s3_secret_key)
) {

  file { 'elasticsearch_snapshot.sh':
    ensure  => file,
    path    => '/usr/local/bin/elasticsearch_snapshot.sh',
    content => template('dc_elasticsearch/elasticsearch_snapshot.erb'),
    owner   => root,
    group   => root,
    mode    => '0754',
  }

  cron { 'elasticsearch_snapshot':
    command => '/usr/local/bin/elasticsearch_snapshot.sh',
    user    => root,
    hour    => 2,
    minute  => 0
  }
}