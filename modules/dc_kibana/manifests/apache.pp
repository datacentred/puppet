class dc_kibana::apache {
  apache::vhost { 'logstash': 
    docroot     => '/var/www/kibana',
    serveradmin => hiera(sysmailaddress),
    require     => File['/var/www/kibana'],
  }
}
