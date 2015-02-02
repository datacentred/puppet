# Class: dc_logstash::client::glance
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
class dc_logstash::client::glance (
  $oslofmt_codec_hash=undef,
){

  dc_logstash::client::register { 'glance_api_log':
    logs   => '/var/log/glance/api.log',
    fields => {
      'type' => 'glance_api',
    },
    codec_hash => $oslofmt_codec_hash,
  }

  dc_logstash::client::register { 'glance_scheduler_log':
    logs   => '/var/log/glance/scheduler.log',
    fields => {
      'type' => 'glance_scheduler',
    },
    codec_hash => $oslofmt_codec_hash,
  }

}
