# Class: dc_logstash::client::mongodb
#
# Forwards MongoDB logs
#
class dc_logstash::client::mongodb {
  
  dc_logstash::client::register { 'mongodb_server':
    logs   => '/var/log/mongodb/mongodb.log',
    fields => {
      'type' => 'mongodb',
    }
  }

}
