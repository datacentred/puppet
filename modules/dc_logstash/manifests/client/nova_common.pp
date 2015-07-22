# Class: dc_logstash::client::nova_common
#
# Logstash config for all Nova nodes
#
class dc_logstash::client::nova_common (
  $oslofmt_codec_hash=undef,
){

  dc_logstash::client::register { 'nova_manage':
    logs       => '/var/log/nova/nova-manage.log',
    fields     => {
      'type' => 'nova-manage',
    },
    codec_hash => $oslofmt_codec_hash,
  }

}
