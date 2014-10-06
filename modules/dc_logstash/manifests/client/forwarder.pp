# Class: dc_logstash::client::forwarder
#
# Much like rsyslog, but does it encrypted and compressed
#
class dc_logstash::client::forwarder {

  service { 'logstash-forwarder':
    ensure    => stopped,
    enable    => false,
  }
  ->
  package { 'logstash-forwarder':
    ensure => absent,
  }

}
