# Class: dc_logstash::server::config::filter_grok_stronghold_openstack
#
# Stronghold OpenStack filter configuration
#
class dc_logstash::server::config::filter_grok_stronghold_openstack {

  logstash::configfile { 'filter_grok_stronghold_openstack':
    source => 'puppet:///modules/dc_logstash/filter_grok_stronghold_openstack',
  }

}
