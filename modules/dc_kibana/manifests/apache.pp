class dc_kibana::apache {
  apache::vhost { 'logstash': 
    docroot => '/var/www/kibana',
    require => File['/var/www/kibana'],
  }
}
