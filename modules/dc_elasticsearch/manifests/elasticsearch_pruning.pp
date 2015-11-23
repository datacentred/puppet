# == Class: dc_elasticsearch::elasticsearch_pruning
#
# Create cron jobs to prune elasticsearch
#
class dc_elasticsearch::elasticsearch_pruning (
  $total_retention    = $dc_elasticsearch::params::total_retention,
  $ssd_tier_retention = $dc_elasticsearch::params::ssd_tier_retention,
) inherits dc_elasticsearch::params {

  ensure_packages(['python-pip'])

  package { 'elasticsearch-curator':
    provider => pip,
    require  => Package['python-pip'],
  }

  file { 'elasticsearch_pruning.sh':
    ensure => absent,
    path   => '/usr/local/bin/elasticsearch_pruning.sh',
  }

  file { '/usr/local/bin/es_pruning.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('dc_elasticsearch/pruning.sh.erb')
  }

  file { '/usr/local/bin/es_tier_pruning.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('dc_elasticsearch/tier_pruning.sh.erb')
  }

  cron { 'elasticsearch_tier_pruning':
    command => '/usr/local/bin/es_tier_pruning.sh >/dev/null',
    user    => 'root',
    hour    => 3,
    minute  => 0,
  }

  cron { 'elasticsearch_pruning':
    command => '/usr/local/bin/es_pruning.sh >/dev/null',
    user    => 'root',
    hour    => 5,
    minute  => 0,
  }

  cron { 'elasticsearch_optimise':
    command => "/usr/local/bin/curator --host localhost --port 9200 optimize indices --older-than ${ssd_tier_retention} >/dev/null",
    user    => 'root',
    hour    => 20,
    minute  => 0,
  }
}
