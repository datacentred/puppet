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
) {

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
    config        => $es_hash,
    java_install  => true,
    init_defaults => $config_hash,
    version       => '1.3.6',
  }

  include ::dc_icinga::hostgroup_elasticsearch

  elasticsearch::instance { 'es-01': }
}
