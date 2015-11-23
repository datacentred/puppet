# == Class: dc_collectd::agent::elasticsearch
#
class dc_collectd::agent::elasticsearch(
  $es_cluster_name,
) {

  file { '/usr/lib/collectd/elasticsearch' :
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    require => Package['collectd'],
    source  => 'puppet:///modules/dc_collectd/elasticsearch',
    recurse => true,
  }

  collectd::plugin::python { 'elasticsearch':
    modulepath    => '/usr/lib/collectd/elasticsearch',
    module        => 'elasticsearch',
    script_source => 'puppet:///modules/dc_collectd/elasticsearch/elasticsearch.py',
    config        => {
      'Verbose' => false,
      'Cluster' => $es_cluster_name,
      'Version' => '1.0',
    },
  }

}
