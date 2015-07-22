# Class: dc_logstash::client::nova
#
# Logstash config for Nova controller node
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_logstash::client::nova (
  $oslofmt_codec_hash=undef,
){

  dc_logstash::client::register { 'nova_api':
    logs       => '/var/log/nova/nova-api.log',
    fields     => {
      'type' => 'nova-api',
    },
    codec_hash => $oslofmt_codec_hash,
  }

  dc_logstash::client::register { 'nova_conductor':
    logs       => '/var/log/nova/nova-conductor.log',
    fields     => {
      'type' => 'nova-conductor',
    },
    codec_hash => $oslofmt_codec_hash,
  }

  dc_logstash::client::register { 'nova_scheduler':
    logs       => '/var/log/nova/nova-scheduler.log',
    fields     => {
      'type' => 'nova-scheduler',
    },
    codec_hash => $oslofmt_codec_hash,
  }

  dc_logstash::client::register { 'nova_cert':
    logs       => '/var/log/nova/nova-cert.log',
    fields     => {
      'type' => 'nova-cert',
    },
    codec_hash => $oslofmt_codec_hash,
  }

  dc_logstash::client::register { 'nova_consoleauth':
    logs       => '/var/log/nova/nova-consoleauth.log',
    fields     => {
      'type' => 'nova-consoleauth',
    },
    codec_hash => $oslofmt_codec_hash,
  }

}
