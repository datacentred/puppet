# Class: dc_logstash::client::apache
#
# Forwards the apache error logs
#
class dc_logstash::client::apache {

  dc_logstash::client::register { 'apache_access':
    logs     => '/var/log/apache2/*access.log',
    fields   => {
      'type' => 'apache',
    }
  }

  dc_logstash::client::register { 'apache_error':
    logs     => '/var/log/apache2/*error.log',
    fields   => {
      'type' => 'apache_error',
    }
  }

}
