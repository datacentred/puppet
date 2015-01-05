# Class: dc_logstash::client::foreman
#
# Logstash config for foreman logs
#
class dc_logstash::client::foreman {

  dc_logstash::client::register { 'foreman_prod':
    logs   => '/var/log/foreman/production.log',
    fields => {
      'type' => 'foreman',
    }
  }

}
