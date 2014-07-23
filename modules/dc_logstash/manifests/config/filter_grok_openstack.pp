# Class: dc_logstash::config::filter_grok_openstack
#
# Openstack filter configuration
#
class dc_logstash::config::filter_grok_openstack {

  logstash::configfile { 'filter_grok_openstack':
    source => 'puppet:///modules/dc_logstash/filter_grok_openstack',
    order  => '10',
  }

}
