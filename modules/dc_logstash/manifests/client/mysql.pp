# Class: dc_logstash::client::mysql
#
# Forwards the mysql error logs
#
class dc_logstash::client::mysql {
  
  dc_logstash::client::forwarder::register { 'mysql_error':
    logs => '/var/log/mysql/error.log',
    type => 'mysql_error',
  }

}
