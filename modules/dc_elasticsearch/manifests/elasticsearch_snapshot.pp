# == Class: dc_elasticsearch::elasticsearch_snapshot
#
# Create a cron job that tells elasticsearch to begin a snapshot
#
class dc_elasticsearch::elasticsearch_snapshot (
  $logstash_server = hiera(logstash_server),
  $backup_name     = $dc_elasticsearch::backup_name,
) {

  include dc_elasticsearch

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