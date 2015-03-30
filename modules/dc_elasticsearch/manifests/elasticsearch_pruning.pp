# == Class: dc_elasticsearch::elasticsearch_pruning
#
# Create a cron job to prune elasticsearch
#
class dc_elasticsearch::elasticsearch_pruning (
  $logstash_server   = $dc_elasticsearch::params::logstash_server,
  $backup_name       = $dc_elasticsearch::params::backup_name,
  $backup_bucket     = $dc_elasticsearch::params::backup_bucket,
  $ceph_access_point = $dc_elasticsearch::params::ceph_access_point,
  $ceph_access_key   = $dc_elasticsearch::params::ceph_access_key,
  $ceph_private_key  = $dc_elasticsearch::params::ceph_private_key,
) inherits dc_elasticsearch::params {

  file { 'elasticsearch_pruning.sh':
    ensure  => file,
    path    => '/usr/local/bin/elasticsearch_pruning.sh',
    content => template('dc_elasticsearch/elasticsearch_pruning.erb'),
    owner   => root,
    group   => root,
    mode    => '0754',
  }

  cron { 'elasticsearch_pruning':
    command => '/usr/local/bin/elasticsearch_pruning.sh',
    user    => root,
    hour    => 3,
    minute  => 0
  }

  ensure_resource('package', 'curl', {'ensure' => 'present' })

}
