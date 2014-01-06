class dc_kibana::apache {
  apache::site { 'logstash': 
    docroot => '/var/www/kibana',
    admin   => 'admin@datacentred.co.uk'
  }
}
