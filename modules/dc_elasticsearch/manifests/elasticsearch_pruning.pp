# == Class: dc_elasticsearch::elasticsearch_pruning
#
# Create a cron job to prune elasticsearch
#
class dc_elasticsearch::elasticsearch_pruning (
  $logstash_server   = $dc_elasticsearch::params::logstash_server,
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

  ensure_packages('curl')

}
