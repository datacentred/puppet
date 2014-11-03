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
  $es_hash
) {

  $half_RAM = floor($::memorysize_mb/2)
  $RAM_unit = 'M'

  $config_hash = {
    'ES_HEAP_SIZE' => "${half_RAM}${RAM_unit}",
  }

  class { '::elasticsearch':
    config        => $::es_hash,
    java_install  =>  true,
    init_defaults => $config_hash,
  }

  # Add icinga config
  unless $::is_vagrant {
    contain ::dc_elasticsearch::icinga
  }

  elasticsearch::instance { 'es-01': }
}