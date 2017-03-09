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
  # SSD tier cleanup
  cron { 'elasticsearch_tier_pruning':
    command => '/usr/local/bin/curator /usr/local/etc/es_tier_pruning.yaml',
    user    => 'root',
    hour    => 3,
    minute  => 0,
  }

  file { '/root/.curator/':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/root/.curator/curator.yml':
    ensure  => file,
    content => file('dc_elasticsearch/curator.yml'),
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
  }

  file { '/usr/local/etc/es_tier_pruning.yaml':
    ensure  => file,
    content => template('dc_elasticsearch/es_tier_pruning.yaml.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
  }

  # Cleanup old indices
  cron { 'elasticsearch_cleanup':
    command => '/usr/local/bin/curator /usr/local/etc/es_cleanup.yaml',
    user    => 'root',
    hour    => 4,
    minute  => 0,
  }

  file { '/usr/local/etc/es_cleanup.yaml':
    ensure  => file,
    content => template('dc_elasticsearch/es_cleanup.yaml.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
  }
}
