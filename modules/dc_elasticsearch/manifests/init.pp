# Class: dc_elasticsearch
#
# Configures elasticsearch and runs one instance
#
# Parameters:
#
# Actions:
#
# Requires: puppet-elasticsearch
#
# Sample Usage:
#
class dc_elasticsearch (
  $es_hash,
  $backup_node        = $dc_elasticsearch::params::backup_node,
  $backup_name        = $dc_elasticsearch::params::backup_name,
  $backup_bucket      = $dc_elasticsearch::params::backup_bucket,
  $ceph_access_point  = $dc_elasticsearch::params::ceph_access_point,
  $ceph_access_key    = $dc_elasticsearch::params::ceph_access_key,
  $ceph_private_key   = $dc_elasticsearch::params::ceph_private_key,
  $ssd_tier_retention = $dc_elasticsearch::params::ssd_tier_retention,
  $total_retention    = $dc_elasticsearch::params::total_retention,
  $ssd_drives,
  $hdd_drives,
) inherits dc_elasticsearch::params {

  validate_array($ssd_drives)
  validate_array($hdd_drives)

  include ::ulimit

  #allows for index tagging to control index storage location within the cluster
  $config_ssd_tag = {'node.storage_type' => 'ssd'}
  $config_hash_for_ssds = merge($config_ssd_tag, $es_hash)

  $config_hdd_tag = {'node.storage_type' => 'hdd'}
  $config_hash_for_hdds = merge($config_hdd_tag, $es_hash)

  #work out what 1/3rd of the host RAM is so it can be reserved for each elasticsearch instance
  $third_ram = floor($::memorysize_mb/3)
  $ram_unit = 'M'
  $third_ram_bytes = ($third_ram * 1024 * 1024)

  $config_hash = {
    'ES_HEAP_SIZE'      => "${third_ram}${ram_unit}",
    'MAX_LOCKED_MEMORY' => $third_ram_bytes,
  }

  ulimit::rule { 'elasticsearch':
      ulimit_domain => 'elasticsearch',
      ulimit_type   => '-',
      ulimit_item   => 'memlock',
      ulimit_value  => $third_ram_bytes,
  }

  class { '::elasticsearch':
    restart_on_change => false,
    java_install      => true,
    init_defaults     => $config_hash,
  }

  include ::dc_icinga::hostgroup_elasticsearch

  elasticsearch::instance { 'ssd':
    datadir => $ssd_drives,
    config  => $config_hash_for_ssds,
  }

  elasticsearch::instance { 'hdd':
    datadir => $hdd_drives,
    config  => $config_hash_for_hdds,
  }

  # $::backup_node is set via foreman
  if $::backup_node {
    include ::dc_elasticsearch::elasticsearch_pruning
    include ::dc_elasticsearch::elasticsearch_snapshot
    include ::dc_elasticsearch::template_install
  }

  tidy { '/var/log/elasticsearch':
    age     => '90d',
    recurse => true,
    matches => [ 'logstash*' ],
  }

  # Needs to be installed on all nodes
  elasticsearch::plugin { 'cloud-aws':
    instances => ['ssd','hdd']
  }

}
