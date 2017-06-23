# Class: dc_logstash::server::config::filter_grok_fail2ban
#
# Fail2ban filter configuration
#
class dc_logstash::server::config::filter_grok_fail2ban {

  logstash::configfile { 'filter_grok_fail2ban':
    source => 'puppet:///modules/dc_logstash/filter_grok_fail2ban',
  }

}
