# == Class: dc_elasticsearch::template_install
#
# Installs custom logstash template into elasticsearch
#
class dc_elasticsearch::template_install {

  ensure_packages(['curl'])

  file { 'logstash_template':
    ensure => present,
    path   => '/usr/local/etc/elasticsearch_logstash_template',
    source => 'puppet:///modules/dc_elasticsearch/logstash_template',
  }

  exec { 'install_logstash_template':
    command     => 'curl -XPUT \'http://localhost:9200/_template/logstash\' -d@/usr/local/etc/elasticsearch_logstash_template',
    subscribe   => File['logstash_template'],
    require     => Package['curl'],
    refreshonly => true,
  }

}
