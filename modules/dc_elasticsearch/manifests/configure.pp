# == Class: dc_elasticsearch::configure
#
# ES cluster configuration
#
class dc_elasticsearch::configure {

  include ::ulimit

  ulimit::rule { 'elasticsearch_files':
      ulimit_domain => 'elasticsearch',
      ulimit_type   => 'soft',
      ulimit_item   => 'nofile',
      ulimit_value  => '65536',
  }

  # Work out what 1/2rd of the host RAM is so it can be reserved for the elasticsearch instance
  $_half_ram_bytes = $::facts['memory']['system']['total_bytes'] >> 1

  class { '::elasticsearch':
    jvm_options => [
      "-Xms${_half_ram_bytes}",
      "-Xmx${_half_ram_bytes}",
    ],
  }

  create_resources('elasticsearch::instance', $dc_elasticsearch::instances)
  create_resources('elasticsearch::plugin', $dc_elasticsearch::plugins)

  tidy { '/var/log/elasticsearch':
    age     => '90d',
    recurse => true,
    matches => [ 'logstash*' ],
  }

}
