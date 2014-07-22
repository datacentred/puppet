# Class: dc_logstash::client::mysql
#
# Forwards the mysql error logs
#
class dc_logstash::client::mysql {

  dc_logstash::client::register { 'mysql_error':
    logs   => '/var/log/mysql/error.log',
    fields => {
      'type' => 'mysql_error',
    }
  }

}
