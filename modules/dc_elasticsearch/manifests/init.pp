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

  $half_RAM = floor($::memorysize_mb/2)
  $RAM_unit = 'M'

  $config_hash = {
    'ES_HEAP_SIZE' => "${half_RAM}${RAM_unit}",
  }

  ulimit::rule {
    'elasticsearch':
      ulimit_domain => 'elasticsearch',
      ulimit_type   => 'hard',
      ulimit_item   => 'memlock',
      ulimit_value  => 'unlimited';
  }

  class { '::elasticsearch':
    config        => $es_hash,
    java_install  => true,
    init_defaults => $config_hash,
  }

  include ::dc_icinga::hostgroup_elasticsearch

  elasticsearch::instance { 'es-01': }
}
