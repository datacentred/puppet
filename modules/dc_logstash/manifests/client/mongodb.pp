# Class: dc_logstash::client::apache
#
# Forwards the apache error logs
#
class dc_logstash::client::mongodb {
  
  dc_logstash::client::register { 'mongod_server':
    logs   => '/var/log/mongodb/mongod.log',
    fields => {
      'type' => 'mongod',
    }
  }

}
