class dc_kibana::apache {
  apache::vhost { 'logstash': 
    docroot     => '/var/www/kibana',
    serveradmin => 'admin@datacentred.co.uk',
    require     => File['/var/www/kibana'],
  }
}
