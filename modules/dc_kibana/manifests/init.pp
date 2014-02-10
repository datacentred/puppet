# Class: dc_kibana
#
# Install and configure Kibana web-based front-end to Elasticsearch
#
class dc_kibana (
  $elasticsearch_host = '',
){

  include dc_kibana::apache

  class { 'dc_kibana::install': } ~>
  class { 'dc_kibana::config': } ~>
  Class ['dc_kibana']
}
