# == Class: dc_elasticsearch::template
#
# Installs custom logstash template into elasticsearch
#
class dc_elasticsearch::template {

  if $::dc_elasticsearch::backup_node {

    file { '/usr/local/etc/elasticsearch_logstash_template':
      ensure => present,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => 'puppet:///modules/dc_elasticsearch/logstash_template',
    } ~>

    exec { 'install_logstash_template':
      command     => 'curl -XPUT \'http://localhost:9200/_template/logstash\' -d@/usr/local/etc/elasticsearch_logstash_template',
      refreshonly => true,
    }

  }

}
