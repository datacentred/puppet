# Class: dc_logstash::client::ceilometer
#
# Configures logstash for ceilometer
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_logstash::client::ceilometer (
    $oslofmt_codec_hash=undef,
){

  dc_logstash::client::register { 'ceilometer_collector_log':
    logs     => '/var/log/ceilometer/ceilometer-collector.log',
    fields   => {
      'type' => 'ceilometer',
    },
    codec_hash => $oslofmt_codec_hash,
  }

  dc_logstash::client::register { 'ceilometer_api_log':
    logs     => '/var/log/ceilometer/ceilometer-api.log',
    fields   => {
      'type' => 'ceilometer',
    },
    codec_hash => $oslofmt_codec_hash,
  }

  dc_logstash::client::register { 'ceilometer_agent_notification_log':
    logs     => '/var/log/ceilometer/ceilometer-agent-notification.log',
    fields   => {
      'type' => 'ceilometer',
    },
    codec_hash => $oslofmt_codec_hash,
  }

  dc_logstash::client::register { 'ceilometer_agent_central_log':
    logs     => '/var/log/ceilometer/ceilometer-agent-central.log',
    fields   => {
      'type' => 'ceilometer',
    },
    codec_hash => $oslofmt_codec_hash,
  }

  dc_logstash::client::register { 'ceilometer_dbsync_log':
    logs     => '/var/log/ceilometer/ceilometer-dbsync.log',
    fields   => {
      'type' => 'ceilometer',
    },
    codec_hash => $oslofmt_codec_hash,
  }

  dc_logstash::client::register { 'ceilometer_expirer_log':
    logs     => '/var/log/ceilometer/ceilometer-expirer.log',
    fields   => {
      'type' => 'ceilometer',
    },
    codec_hash => $oslofmt_codec_hash,
  }

  dc_logstash::client::register { 'ceilometer_agent_compute_log':
    logs     => '/var/log/ceilometer/ceilometer-agent-compute.log',
    fields   => {
      'type' => 'ceilometer',
    },
    codec_hash => $oslofmt_codec_hash,
  }

}
