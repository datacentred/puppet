# Class: dc_profile::openstack::cinder_logstash
#
# Configures logstash for cinder
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::cinder_logstash {

  dc_logstash::client::register { 'cinder_manage_log':
    logs => '/var/log/cinder/cinder-manage.log',
    type => 'cinder_manage',
  }

  dc_logstash::client::register { 'cinder_scheduler_log':
    logs => '/var/log/cinder/cinder-scheduler.log',
    type => 'cinder_scheduler',
  }

  dc_logstash::client::register { 'cinder_api_log':
    logs => '/var/log/cinder/cinder-api.log',
    type => 'cinder_api',
  }

  dc_logstash::client::register { 'cinder_volume_log':
    logs => '/var/log/cinder/cinder-volume.log',
    type => 'cinder_volume',
  }

}
