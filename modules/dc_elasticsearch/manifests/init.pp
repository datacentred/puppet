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
  $es_datadir         = $dc_elasticsearch::params::elasticsearch_data_dir,
  $backup_name        = $dc_elasticsearch::params::backup_name,
  $backup_bucket      = $dc_elasticsearch::params::backup_bucket,
  $ceph_access_point  = $dc_elasticsearch::params::ceph_access_point,
  $ceph_access_key    = $dc_elasticsearch::params::ceph_access_key,
  $ceph_private_key   = $dc_elasticsearch::params::ceph_private_key,
) inherits dc_elasticsearch::params {

  include ::ulimit

  $half_RAM = floor($::memorysize_mb/2)
  $RAM_unit = 'M'
  $half_RAM_bytes = ($half_RAM * 1024 * 1024)

  $config_hash = {
    'ES_HEAP_SIZE'      => "${half_RAM}${RAM_unit}",
    'MAX_LOCKED_MEMORY' => $half_RAM_bytes,
  }

  ulimit::rule { 'elasticsearch':
      ulimit_domain => 'elasticsearch',
      ulimit_type   => '-',
      ulimit_item   => 'memlock',
      ulimit_value  => $half_RAM_bytes,
  }

  class { '::elasticsearch':
    config            => $es_hash,
    datadir           => $es_datadir,
    restart_on_change => false,
    java_install      => true,
    init_defaults     => $config_hash,
    version           => '1.3.6',

  }

  exec { 'setup-backup-to-ceph':
    command => "curl -XPUT 'http://localhost:9200/_snapshot/${backup_name}' -d '{ \"type\": \"s3\", \"settings\": { \"bucket\": \"${backup_bucket}\", \"endpoint\": \"${ceph_access_point}\", \"access_key\": \"${ceph_access_key}\", \"secret_key\": \"${ceph_private_key}\" } }'",
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    unless  => "curl -XGET 'http://localhost:9200/_snapshot/?pretty' | grep \"${backup_name}\"",
  }

  include ::dc_icinga::hostgroup_elasticsearch

  elasticsearch::instance { 'es-01': }
}
