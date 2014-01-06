class dc_profile::kibana {
  include apache
  class {'dc_kibana':
    elasticsearch_host => hiera(logstash_server)
  }
}
