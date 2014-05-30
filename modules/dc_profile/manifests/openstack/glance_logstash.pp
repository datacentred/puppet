# Class: dc_profile::openstack::glance_logstash
#
# Configures logstash for glance
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::glance_logstash {

  dc_logstash::client::register { 'glance_api_log':
    logs => '/var/log/glance/api.log',
    type => 'glance_api',
  }

  dc_logstash::client::register { 'glance_scheduler_log':
    logs => '/var/log/glance/scheduler.log',
    type => 'glance_scheduler',
  }

}
