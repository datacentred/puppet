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
  $ssd_drives,
  $version            = $dc_elasticsearch::params::elasticsearch_version,
  $backup_node        = $dc_elasticsearch::params::backup_node,
  $backup_name        = $dc_elasticsearch::params::backup_name,
  $backup_bucket      = $dc_elasticsearch::params::backup_bucket,
  $ceph_access_point  = $dc_elasticsearch::params::ceph_access_point,
  $ceph_access_key    = $dc_elasticsearch::params::ceph_access_key,
  $ceph_private_key   = $dc_elasticsearch::params::ceph_private_key,
  $total_retention    = $dc_elasticsearch::params::total_retention,
) inherits dc_elasticsearch::params {

  validate_array($ssd_drives)

  include ::ulimit

  #allows for index tagging to control index storage location within the cluster
  #n.b. originally used with spinning rust but now fully SSD
  $config_ssd_tag = {'node.attr.storage_type' => 'ssd'}
  $config_hash_for_ssds = merge($config_ssd_tag, $es_hash)

  #work out what 1/2rd of the host RAM is so it can be reserved for the elasticsearch instance
  $half_ram = floor($::memorysize_mb/2)
  $ram_unit = 'M'
  $half_ram_bytes = ($half_ram * 1024 * 1024)

  $config_hash = {
    'MAX_LOCKED_MEMORY' => $half_ram_bytes,
  }

  $jvm_options = [
    "-Xms${half_ram_bytes}",
    "-Xmx${half_ram_bytes}",
  ]

  ulimit::rule { 'elasticsearch_files':
      ulimit_domain => 'elasticsearch',
      ulimit_type   => 'soft',
      ulimit_item   => 'nofile',
      ulimit_value  => '65536',
  }

  class { '::elasticsearch':
    restart_on_change => false,
    java_install      => true,
    manage_repo       => true,
    repo_version      => '5.x',
    package_pin       => true,
    version           => $version,
    init_defaults     => $config_hash,
    jvm_options       => $jvm_options,
  }

  include ::dc_icinga::hostgroup_elasticsearch

  elasticsearch::instance { 'ssd':
    datadir => $ssd_drives,
    config  => $config_hash_for_ssds,
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
  elasticsearch::plugin { 'repository-s3':
    instances => ['ssd']
  }

  elasticsearch::plugin { 'x-pack':
    instances => ['ssd']
  }

}
