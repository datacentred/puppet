# == Class: dc_elasticsearch::pruning
#
# Create cron jobs to prune elasticsearch
#
class dc_elasticsearch::pruning {

  if $::dc_elasticsearch::backup_node {

    $_total_retention = $dc_elasticsearch::total_retention

    file { '/usr/local/bin/es_pruning_and_cleanup':
      ensure  => file,
      content => file('dc_elasticsearch/es_pruning_and_cleanup'),
      owner   => 'root',
      group   => 'root',
      mode    => '0554',
    }

    cron { 'elasticsearch_pruning_and_cleanup':
      command => '/usr/local/bin/es_pruning_and_cleanup',
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

    file { '/usr/local/etc/es_cleanup.yaml':
      ensure  => file,
      content => template('dc_elasticsearch/es_cleanup.yaml.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0640',
    }

  }

}
