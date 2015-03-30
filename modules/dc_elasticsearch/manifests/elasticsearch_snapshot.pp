# == Class: dc_elasticsearch::elasticsearch_snapshot
#
# Create cron jobs to run elasticsearch snapshots and prune old snapshots
#
class dc_elasticsearch::elasticsearch_snapshot (
  $logstash_server   = $dc_elasticsearch::params::logstash_server,
  $backup_name       = $dc_elasticsearch::params::backup_name,
  $backup_bucket     = $dc_elasticsearch::params::backup_bucket,
  $ceph_access_point = $dc_elasticsearch::params::ceph_access_point,
  $ceph_access_key   = $dc_elasticsearch::params::ceph_access_key,
  $ceph_private_key  = $dc_elasticsearch::params::ceph_private_key,
) inherits dc_elasticsearch::params {

#  notify {$ceph_access_key:}

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

  package { 'python-pip':
    ensure => installed,
  } ->

  package { 'boto':
    ensure   => present,
    provider => 'pip',
  } ->

  package { 'datetime':
    ensure   => present,
    provider => 'pip',
  }

  ensure_resource('package', 'curl', {'ensure' => 'present' })

}
