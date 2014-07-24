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
    logs     => '/var/log/cinder/cinder-manage.log',
    fields   => {
      'type' => 'cinder_manage',
      'tags' => 'oslofmt',
    }
  }

  dc_logstash::client::register { 'cinder_scheduler_log':
    logs => '/var/log/cinder/cinder-scheduler.log',
    fields   => {
      'type' => 'cinder_scheduler',
      'tags' => 'oslofmt',
    }
  }

  dc_logstash::client::register { 'cinder_api_log':
    logs => '/var/log/cinder/cinder-api.log',
    fields   => {
      'type' => 'cinder_api',
      'tags' => 'oslofmt',
    }
  }

  dc_logstash::client::register { 'cinder_volume_log':
    logs => '/var/log/cinder/cinder-volume.log',
    fields   => {
      'type' => 'cinder_volume',
      'tags' => 'oslofmt',
    }
  }

}
