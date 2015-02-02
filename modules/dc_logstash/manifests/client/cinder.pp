# Class: dc_logstash::client::cinder
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
class dc_logstash::client::cinder (
  $oslofmt_codec_hash=undef,
){

  dc_logstash::client::register { 'cinder_manage_log':
    logs   => '/var/log/cinder/cinder-manage.log',
    fields => {
      'type' => 'cinder_manage',
    },
    codec_hash => $oslofmt_codec_hash,
  }

  dc_logstash::client::register { 'cinder_scheduler_log':
    logs   => '/var/log/cinder/cinder-scheduler.log',
    fields => {
      'type' => 'cinder_scheduler',
    },
    codec_hash => $oslofmt_codec_hash,
  }

  dc_logstash::client::register { 'cinder_api_log':
    logs   => '/var/log/cinder/cinder-api.log',
    fields => {
      'type' => 'cinder_api',
    },
    codec_hash => $oslofmt_codec_hash,
  }

  dc_logstash::client::register { 'cinder_volume_log':
    logs   => '/var/log/cinder/cinder-volume.log',
    fields => {
      'type' => 'cinder_volume',
    },
    codec_hash => $oslofmt_codec_hash,
  }

}
