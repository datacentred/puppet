# Class: dc_profile::openstack::horizon_logstash
#
# Configures logstash for horizon
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::horizon_logstash {

  dc_logstash::client::register { 'horizon_log':
    logs   => '/var/log/horizon/horizon.log',
    fields => {
      'type' => 'horizon',
    }
  }

  dc_logstash::client::register { 'horizon_access_log':
    logs   => '/var/log/apache2/horizon_access.log',
    fields => {
      'type' => 'horizon',
    }
  }

  dc_logstash::client::register { 'horizon_error_log':
    logs   => '/var/log/apache2/horizon_error.log',
    fields => {
      'type' => 'horizon',
    }
  }
}
