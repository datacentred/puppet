# Class: dc_logstash::server::config::filter_grok_libvirt
#
# Server side configuration for libvirt
#
class dc_logstash::server::config::filter_grok_libvirt {

  logstash::configfile { 'filter_grok_libvirt':
    source => 'puppet:///modules/dc_logstash/filter_grok_libvirt',
  }

}
