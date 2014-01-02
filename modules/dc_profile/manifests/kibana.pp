class dc_profile::kibana {
  class {'dc_kibana':
    elasticsearch_host => 'localhost'
  }
}
