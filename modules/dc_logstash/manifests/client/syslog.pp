# Class: dc_logstash::client::syslog
#
# Forwards syslog
#
class dc_logstash::client::syslog {

  dc_logstash::client::register { 'syslog':
    logs          => '/var/log/syslog',
    fields        => {
      'type'      => 'syslog',
    }
  }
}
