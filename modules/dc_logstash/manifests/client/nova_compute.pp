# Class: dc_logstash::client::nova_compute
#
# Logstash config for Nova on compute nodes
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_logstash::client::nova_compute (
  $oslofmt_codec_hash=undef,
){

  dc_logstash::client::register { 'nova_manage':
    logs   => '/var/log/nova/nova-manage.log',
    fields => {
      'type' => 'nova-manage',
    },
    codec_hash => $oslofmt_codec_hash,
  }

  dc_logstash::client::register { 'nova_compute':
    logs   => '/var/log/nova/nova-compute.log',
    fields => {
      'type' => 'nova-compute',
    },
    codec_hash => $oslofmt_codec_hash,
  }

}
