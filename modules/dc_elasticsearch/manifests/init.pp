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
) inherits dc_elasticsearch::params {

  include ::ulimit

  #allows for index tagging to control index storage location within the cluster
  $config_ssd_tag = {'node.storage_type' => 'ssd'}
  $config_hash_for_ssds = merge($config_ssd_tag, $es_hash)

  $config_hdd_tag = {'node.storage_type' => 'hdd'}
  $config_hash_for_hdds = merge($config_hdd_tag, $es_hash)

  #work out what 1/4th of the host RAM is so it can be reserved for each elasticsearch instance
  $quarter_RAM = floor($::memorysize_mb/4)
  $RAM_unit = 'M'
  $quarter_RAM_bytes = ($quarter_RAM * 1024 * 1024)

  $config_hash = {
    'ES_HEAP_SIZE'      => "${quarter_RAM}${RAM_unit}",
    'MAX_LOCKED_MEMORY' => $quarter_RAM_bytes,
  }

  ulimit::rule { 'elasticsearch':
      ulimit_domain => 'elasticsearch',
      ulimit_type   => '-',
      ulimit_item   => 'memlock',
      ulimit_value  => $quarter_RAM_bytes,
  }

  class { '::elasticsearch':
    restart_on_change => false,
    java_install      => true,
    init_defaults     => $config_hash,
    version           => '1.7.1',
  }

  include ::dc_icinga::hostgroup_elasticsearch

  elasticsearch::instance { 'ssd-01':
    datadir => [ '/var/storage/ssd_sdb', '/var/storage/ssd_sdc' ],
    config  => $config_hash_for_ssds,
  }
  
  elasticsearch::instance { 'hdd-01':
    datadir => [ '/var/storage/hdd_sdd', '/var/storage/hdd_sde', '/var/storage/hdd_sdf', '/var/storage/hdd_sdg' ],
    config  => $config_hash_for_hdds,
  }

  # $::backup_node is set via foreman
  if $::backup_node {
    include dc_elasticsearch::elasticsearch_pruning
    include dc_elasticsearch::elasticsearch_snapshot
  }

}
