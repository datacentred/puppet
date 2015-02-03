# Class: dc_logstash::client::syslog
#
# Forwards syslog
#
class dc_logstash::client::syslog (
  $syslog_codec_hash=undef,
){

  dc_logstash::client::register { 'syslog':
    logs          => '/var/log/syslog',
    fields        => {
      'type'      => 'syslog',
    },
    codec_hash    => $syslog_codec_hash,
  }
}
